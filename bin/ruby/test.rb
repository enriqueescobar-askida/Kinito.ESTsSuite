#!/usr/bin/ruby -w
# Call using "ruby sifakaSNPCTGparser.rb -f a.txt"

require 'getoptlong'
require 'csv'
# specify the options we accept and initialize the option parser
opts          = GetoptLong.new(
  [ "--file", "-f",   GetoptLong::REQUIRED_ARGUMENT ]
);

# process the parsed options
sifakaSNPCTG  = "";
opts.each do |opt, arg|
  puts "Option: #{opt}, arg #{arg.inspect}"
  sifakaSNPCTG= arg;
end

# method for parsing in_line
def parse(aLine)
#test number of arguments
#    if aLine =~ /^(\S*)\s[0-9]+\s(.+)\s[0-9]+\s[0-9]+\s[0-9]+([+|-])\s([0-9]+)\s([0-9]+)\s([0-9]+)\s([0-9]+)\s(.*)$/
      line_array = aLine.split(' ')
      snp_ID  = line_array[0];
      ctg_ID  = line_array[2];
      signus  = line_array[6];
      qrstar  = line_array[7].to_i;
      qrstop  = line_array[8].to_i;
      htstar  = line_array[9].to_i;
      htstop  = line_array[10].to_i;
      aligne  = line_array[11];
      print "snp_ID:",snp_ID, "ctg_ID:", ctg_ID, "aligne:", aligne, "\n"
      return snp_ID;
#    else
      print  "Error: unable to parse line";
      return  "";
#    end
end

if  File.exists?(sifakaSNPCTG)
  puts  File.atime(sifakaSNPCTG);
  puts  File.mtime(sifakaSNPCTG);
  puts  File.dirname(File.expand_path(sifakaSNPCTG));
  puts  File.basename(sifakaSNPCTG);
  puts  File.size(sifakaSNPCTG);
  puts  File.ftype(sifakaSNPCTG);
else
  puts  "File <"+sifakaSNPCTG+"> does no t exist!";
  exit(1);
end

# Read File with Exception Handling
counter       = 1;
begin
#  in_file     = File.new(sifakaSNPCTG, "r")
#  while (in_line = in_file.gets)
  CSV.open(sifakaSNPCTG, 'r', " ") do |line_array|
    print "In while: counter =", counter, "\n"
#    in_line.chomp;
#    uneline=parse(in_line);
    snp_ID  = line_array[0];
      ctg_ID  = line_array[2];
      signus  = line_array[6];
      qrstar  = line_array[7].to_i;
      qrstop  = line_array[8].to_i;
      htstar  = line_array[9].to_i;
      htstop  = line_array[10].to_i;
      aligne  = line_array[11];
      print "snp_ID:",snp_ID, "ctg_ID:", ctg_ID, "aligne:", aligne, "\n"
    #puts "#{in_line} #{uneline}"
    counter   = counter+1;
  end
#in_file.close

rescue        SystemCallError
  $stderr.print "IO Exception: "+$!;
  in_file.close;
  raise;
end


