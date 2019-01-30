#!/usr/bin/ruby -w

require "proteo_analysis"

class MascotPeptide < Peptide

  def to_s
    string = @sequence + "\n"
    @query_protein_list.each {|query_protein|
      string << "\tquery" << query_protein['query_number'].to_s << "\t"
      string << "ionsScore=" << query_protein['peptide_score'].to_s << "\n"
      query_protein['protein_hash'].each_key {|key|
        string << "\t\tac:" << key << "\tmultiplicity:" << query_protein['protein_hash'][key].to_s << "\n"
      }
    }
    return string
  end
  
end

# Stores the protein informations and the list of associated peptides
class MascotProtein < Protein
  attr_accessor :mass
  # Stores the peptide best score and associated multiplicity.
  # In case the same peptide sequence is matched by different queries,
  # only the best score is used to compute the protein score.
  attr_accessor :best_peptide_hash

  def initialize ac
    super ac
    @mass = 0
    @best_peptide_hash = Hash.new
  end

  def add_peptide sequence, ions_score, multiplicity, query_number
    @peptide_list << {
      'sequence' => sequence,
      'ions_score' => ions_score,
      'multiplicity' => multiplicity,
      'query_number' => query_number
    }
    # If this peptide score is better than a previous one, replace it.
    if @best_peptide_hash[sequence].nil? or @best_peptide_hash[sequence]['ions_score'] < ions_score
      @best_peptide_hash[sequence] = {
        'ions_score' => ions_score,
        'multiplicity' => multiplicity
      }
    end
  end

  # The protein score is computed similarly to the Mascot peptide summary page
  def compute_score tolerance_factor
    @best_peptide_hash.each_value {|peptide|
      temp_score = peptide['ions_score'] - 10 * tolerance_factor * Math.log10(peptide['multiplicity'])
      if temp_score > 0
        @score += temp_score
      end
    }
  end

  def to_s
    string = "ac:#@ac\t"
    string << "mass:#@mass\t"
    string << "score:#@score\n"
    string << @description << "\n"
    string << "-- Peptide list --\n"
    @peptide_list.each_index {|i|
      string << (i + 1).to_s
      string << "\tions_score:" << @peptide_list[i]['ions_score'].to_s
      string << "\tmultiplicity:" << @peptide_list[i]['multiplicity'].to_s
      string << "\tquery" << @peptide_list[i]['query_number'].to_s
      string << "\t" << @peptide_list[i]['sequence'] << "\n"
    }
    string << "-- Best peptide list --\n"
    @best_peptide_hash.each_key {|sequence|
      string << "\tions_score:" << @best_peptide_hash[sequence]['ions_score'].to_s
      string << "\tmultiplicity:" << @best_peptide_hash[sequence]['multiplicity'].to_s
      string << "\t" << sequence << "\n"
    }
    return string
  end

end

# The main class representing a Mascot Analysis .dat file,
# holding parameters information as well as queries, peptides and proteins lists.
class MascotAnalysis < ProteomicsAnalysis

  def to_s
    return "tolerance_factor=#{get_tolerance_factor}\n" + super
  end

  def exportCSV(file)
    csv_protein_list = @protein_list
    CSV::Writer.generate(file, "\t") do |csv|
      csv << ["Mascot file", @analysis_file]
      csv << ["MS data file", @parameters_hash['FILE']]
      csv << ["Protein data bank", @parameters_hash['DB'] + " " + @search_database]
      csv << ["Start time", Time.at(@date - @run_time)]
      csv << ["End time", Time.at(@date)]
      csv << ["Mascot version", @version]
      csv << ["Annotation", @annotation]
      csv << ["Accession number", "Mass", "Total score", "Peptides matched", "Description", "Annotation"]
      for i in 0..csv_protein_list.length - 1
        str = []
        str << csv_protein_list[i].ac
        str << csv_protein_list[i].mass
        str << sprintf("%.2f", csv_protein_list[i].score)
        str << csv_protein_list[i].peptide_list.length
        str << csv_protein_list[i].description
        str << csv_protein_list[i].annotation
        csv << str
      end
    end
  end

  # The tolerance factor as defined in Mascot scripts; used to compute protein scores
  def get_tolerance_factor
    if @parameters_hash.has_key? "ITOL"
      tolerance_factor = @parameters_hash['ITOL'].to_f
    else
      tolerance_factor = 0.0
    end
    if @parameters_hash['ITOLU'] =~ /mmu/i
      tolerance_factor = tolerance_factor / 1000
    end
    tolerance_factor = Math.sqrt(tolerance_factor ** 2 + 0.0625)
    return tolerance_factor
  end

  def compute_protein_scores
    tolerance_factor = get_tolerance_factor
    @protein_hash.each_value {|protein|
      protein.compute_score tolerance_factor
    }
    # Sort the list of proteins for this analysis by decreasing score
    @protein_list = @protein_hash.values.sort {|a,b| b.score <=> a.score}
  end

  # Parse a Mascot .dat file and fill in the MascotAnalysis attributes
  def parse stringIO
    section_name = ""

    stringIO.each_line {|line|
      # Get the section name
      if line =~ /^Content-Type: application\/x-Mascot; name="([^\"]*)"/
        section_name = $1
      # Parameters section
      elsif section_name == "parameters" && line =~ /^([^=]*)=(.*)$/
        @parameters_hash[$1] = $2
      # Header section
      elsif section_name == "header" && line =~ /^exec_time=(\d+)$/
        @run_time = $1.to_f
      elsif section_name == "header" && line =~ /^date=(\d+)$/
        @date = $1.to_f
      elsif section_name == "header" && line =~ /^queries=(\d+)$/
        @number_of_queries = $1.to_i
      elsif section_name == "header" && line =~ /^version=(.*)$/
        @version = $1
      elsif section_name == "header" && line =~ /^release=(.*)$/
        @search_database = $1
      # Peptides section
      elsif section_name == "peptides" && line =~ /^q(\d+)_p(\d+)=([^;]*);(.*)$/
        # Get all the parameters for this peptide in this query
        query_num = $1.to_i
        peptide_num = $2.to_i
        peptide_params = $3
        protein_params = $4
        missed_cleavages,
        peptide_mr,
        delta,
        num_ions_matched,
        peptide_string,
        peaks_used_from_ions1,
        modifications,
        ions_score,
        ion_series,
        peaks_used_from_ions2,
        peaks_used_from_ions3 = peptide_params.split(/,/)
        # If the query does not exist yet, create it
        if @query_list[query_num - 1].nil?
          @query_list[query_num - 1] = Query.new query_num
        end
        # The peptides are ordered in the peptide list of the query
        @query_list[query_num - 1].add_peptide peptide_string
        # If the peptide does not exist yet, create it
        if !@peptide_hash.has_key? peptide_string
          @peptide_hash[peptide_string] = MascotPeptide.new peptide_string
        end
        # Will contain the list of proteins associated to this peptide for this query
        peptide_protein_hash = Hash.new
        # Get the list of proteins for this peptide
        protein_params.split(/,/).each {|protein|
          ac, frame_num, peptide_start, peptide_end, multiplicity = protein.split(/:/)
          # Remove the leading and trailing '"'
          ac = ac.gsub(/^\"(.*)\"$/, '\1')
          # If the protein does not exist yet, create it
          if !@protein_hash.has_key? ac
            @protein_hash[ac] = MascotProtein.new ac
          end
          # Add this peptide to peptide list of the protein along with other query info
          @protein_hash[ac].add_peptide peptide_string, ions_score.to_f, multiplicity.to_i, query_num
          # Set the multiplicity of the peptide for this protein in this query
          peptide_protein_hash[ac] = multiplicity.to_i
        }
        # Add query and protein information to this peptide
        @peptide_hash[peptide_string].add_query_protein query_num, ions_score.to_f, peptide_protein_hash
      # Proteins section
      elsif section_name == "proteins" && line =~ /^\"(.*)\"=([\d.]+),\"(.*)\"$/
        ac = $1
        mass = $2
        description = $3
        # If the protein does not exist yet, create it
        if !@protein_hash.has_key? ac
          @protein_hash[ac] = MascotProtein.new ac
        end
        @protein_hash[ac].mass = mass
        @protein_hash[ac].description = description
      # Queries section
      elsif section_name =~ /^query(\d+)/
        query_num = $1.to_i
        if line =~ /^title=(.*)$/
          sample_name, start_scan, end_scan, charge = $1.split(/%2e/)
          # If the query does not exist yet, create it
          if @query_list[query_num - 1].nil?
            @query_list[query_num - 1] = Query.new query_num
          end
          # Update this query with additional information
          @query_list[query_num - 1].start_scan = start_scan.to_i
          @query_list[query_num - 1].end_scan = end_scan.to_i
          @query_list[query_num - 1].charge = charge.to_i
        end
      end
    }
    # Once the file is parsed, the protein scores can be computed from their peptide scores
    compute_protein_scores
  end

end
