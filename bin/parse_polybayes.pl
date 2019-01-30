#!/usr/local/bin/perl
#
#script to parse some information out of polybayes output
#to make it a little more digestible
#
#13 Apr 2004 By Lee
#
#useage:
#parse_polybayes.pl (pvalue) (polybayesfile)
#
#where pvalue is the minimum probability to accept
#and polybayesfile is the file that has the polybayes output
#note that output has been left at STDOUT.  If you want it
#elsewhere use a redirect.
#
#21 June 2004
#updated to include the clone identities after each sequence

use strict;
my $min_p_snp = $ARGV[0];
my $infile = $ARGV[1];

start by opening the ncbi_xref file
from biodata/spruce_access
my $xref_file = "";

my %clone_xref;
my %ncbi_seq_xref;
open (XREF, "<$xref_file")||die "cannot open $xref_file\n";
while (<XREF>){
  chomp $_;
  if ($_ =~ m/(GQ.*)\s+(MN\d{7})/){
    my $GQid = $1;
    my $MNid = $2;
    $ncbi_seq_xref{$MNid} = $GQid;
    if ($GQid =~ m/(GQ\d{3})(\w?)(.*)(\w{1}\d{2})/){
      my $clone = "$1$2$4";
      $clone_xref{$MNid} = $clone;
    };
  };
};

#print "looking through $infile for at least $min_p_snp probability\n";
open (INFILE, "<$infile")|| die "cannot open $infile\n";
my $snp_count;
print "contig\tcontig_position\tP_SNP\tseq_mnid\tseq_clone\tbase\tphd_value\tsequence_position\tseqs_at_position\n";
while (<INFILE>){
    if (/(P_SNP\:\s?)(\d\.?\d*)(\s?)/){
	$snp_count++;
	my $snp_snp = $1;
	my $p_snp = $2;
#	print "$p_snp\n";
	my %seq_info_list;    #a hash of arrays
	if ($p_snp ge $min_p_snp){
#	    print "$snp_snp $p_snp\n";
#	    print "$_\n";
	    my @seq_list;
	    my @line = split(/\s/, $_);
	    my $subject;
	    my @column = split(/\,/, $line[39]);
	    my $tmp_line = $line[39];
	    my @line_array = split(/TEMPLATE\,/, $tmp_line);
#	    print "$line[3]\t$line[11]\t$line[15]\t$column[1]\t";
	    shift @line_array;
	    foreach my $seq_blame (@line_array){
	        #next line prints contig, contig_position, and P_SNP
		print "$line[3]\t$line[11]\t$line[15]\t";
		my %seen_items;
		my @seen_items;
		my @tmp_array2 = split(/\,/, $seq_blame);
		my $seq_name_for_hash = $tmp_array2[0];
		foreach my $element (@tmp_array2){
		    unless (exists $seen_items{$element}){
			unless ($element =~ /\;/){
			    push @{$seq_info_list{$seq_name_for_hash}}, $element;
			    $seen_items{$element} = 1;
			    push @seen_items, $element;
			};
		    };
		};
#		foreach my $key  (@seen_items[0 .. 3]){
#		    print "$key\t";
#		};
		my $seq_to_print = $seen_items[0];
		my $clone_to_print = $clone_xref{$seq_to_print};
		print "$seq_to_print\t$clone_to_print\t";
		print "$seen_items[1]\t$seen_items[2]\t$seen_items[3]\t";
		print scalar(@line_array)."\n";
		push @seq_list, $seq_name_for_hash;
	    };
#	    print "\n";
#	    shift @line_array;     #because the line starts with TEMPLATE
#	    my $member_count = @line_array;
#	    if ($line[39] =~ m/(TEMPLATE\,)(\w+)(\,?)/){
#		$subject = $2;
#	    };
#	    print "$line[3]\t$line[11]\t$line[15]\t$column[1]\t$member_count\t$line_array[0]\n";
	}else{
#	    print "$p_snp is less than $min_p_snp\n";
	};
    };
};
print "there were $snp_count line with p_snp in them\n";
