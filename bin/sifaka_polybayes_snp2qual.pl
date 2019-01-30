#!/usr/bin/perl-w

#uses
use				diagnostics		;
use				strict			;
use				warnings		;
use				POSIX			;
use				Getopt::Long	;
use				Carp			;

#scalar vars
my	$cont_id					;
my	$snp_pos					;
my	$in_file					;
my	$myUsaj		= "Usage: perl sifaka_polybayes_snp2qual.pl -c Contig -p SNPposition -q qualtabfile"	;
my	$in_line					;

#array vars
my	@qualinfo	= ()			;

#hash vars

#cmd line processing
Getopt::Long::Configure("bundling","no_ignore_case","require_order")	;
GetOptions		(	'c=s'  => \$cont_id	,
          'p=i'  => \$snp_pos	,
          'q=s'  => \$in_file
        )				;

#checking command line options
#qualtabfile not entered
if	( !defined($in_file) or ($in_file eq "") )
{
  print	( STDERR "You haven t entered the qualtabfile!\n" ) ;
  die		( $myUsaj."\n")		;
}
#qualtabfile is a directory
if	(-d $in_file)
{
  print	( STDERR "qualtabfile file (".$in_file.") is a directory not a file!\n" ) ;
  die		( $myUsaj."\n")		;
}
#qualtabfile not exists
if	(!-e $in_file)
{
  print	( STDERR "qualtabfile file (".$in_file.") not exists!\n" ) ;
  die		( $myUsaj."\n")		;
}
#contig not exists
if	(!defined $cont_id || $cont_id eq "" )
{
  print	( STDERR "contig (".$cont_id.") not exists!\n" ) ;
  die		( $myUsaj."\n")		;
}
#position not exists
if	(!defined $snp_pos || $snp_pos eq "" )
{
  print	( STDERR "position (".$snp_pos.") not exists!\n" ) ;
  die		( $myUsaj."\n")		;
}

chomp($in_file)					;
chomp($snp_pos)					;
chomp($cont_id)					;

#file opening for read
open	( QUALFILE, "<".$in_file )		or		die	( "Cannot open  the file : $in_file\n" );
print	( STDERR "Reading file (".$in_file.")\n" )					;

@qualinfo		=	<QUALFILE>	;
chomp(@qualinfo)				;

#close the QUALFILE file
close	( QUALFILE )					or		die ( "Cannot close the file : $in_file\n" );

#fetch the contig in qualtabfile
@qualinfo		=	grep(/^$cont_id/,@qualinfo)	;

#catch the unique hit
$in_line		=	$qualinfo[0];

#fetch qual list from qualtabfile
@qualinfo		=	split(/\s/,$in_line);
$in_line		=	$qualinfo[1];
# print	( STDERR $in_line."\n" ) ;

#fetch qual from list
@qualinfo		=	split(/,/,$in_line)	;
if	( $snp_pos > @qualinfo )
{
  print	( STDERR "position out of read range\t".@qualinfo."<".$snp_pos."\n" )	;
# 	print	( STDOUT "0\n" )	;
  exit (0)					;
}
else
{
  $in_line		=	$qualinfo[$snp_pos]	;
  print	( STDOUT $in_line."\n" )	;
}
