#!/usr/bin/perl-w

#uses
use				diagnostics		;
use				strict			;
use				warnings		;
use				POSIX			;
use				Getopt::Long	;
use				Carp			;

#scalar vars
my	$in_file					;
my	$outfile					;
my	$estfile					;
my	$seqfile					;
my	$quafile					;
my	$snpline					;
my	$myUsaj		= "Usage: perl sifaka_polybayes_snp2contig.pl -d dir8file -o snp2contigfile -e blastestsfile -s seqtabfile -q qualtabfile"		;
my	$hit_lo						;
my	$hit_nu						;
my	$hit_ca						;

#array vars
my	@dir8info	=	()				;
my	@snpid		=	my @ctgid = my @snplo = my @snpnu = my @snpca = ()	;
my	@readinfo	=	my @est_info = ()	;
my	@hit_info	=	()				;

#hash vars

#cmd line processing
Getopt::Long::Configure("bundling","no_ignore_case","require_order")	;
GetOptions		(	'd=s'	=> \$in_file	,
          'o=s'	=> \$outfile	,
          'e=s'	=> \$estfile	,
          's=s'	=> \$seqfile	,
          'q=s'	=> \$quafile
        )				;

#checking command line options
#dir8file not entered
if	( !defined($in_file) or ($in_file eq "") )
{
  print	( STDERR "You haven t entered the dir8file!\n" ) ;
  die		( $myUsaj."\n")		;
}
#dir8file is a directory
if	(-d $in_file)
{
  print	( STDERR "dir8file file (".$in_file.") is a directory not a file!\n" ) ;
  die		( $myUsaj."\n")		;
}
#dir8file not exists
if	(!-e $in_file)
{
  print	( STDERR "dir8file file (".$in_file.") not exists!\n" ) ;
  die		( $myUsaj."\n")		;
}
#snp2contig not entered
if	( !defined($outfile) or ($outfile eq "") )
{
  print	( STDERR "You haven t entered the snp2contig!\n" ) ;
  die		( $myUsaj."\n")		;
}
#snp2contig is a directory
if	(-d $outfile)
{
  print	( STDERR "snp2contig file (".$outfile.") is a directory not a file!\n" ) ;
  die		( $myUsaj."\n")		;
}
#snp2contig not exists
if	( -e $outfile)
{
  print	( STDERR "snp2contig file (".$outfile.") exists!\n" ) ;
  die		( $myUsaj."\n")		;
}
#estfile not entered
if	( !defined($estfile) or ($estfile eq "") )
{
  print	( STDERR "You haven t entered the estfile!\n" ) ;
  die		( $myUsaj."\n")		;
}
#estfile is a directory
if	(-d $estfile)
{
  print	( STDERR "estfile file (".$estfile.") is a directory not a file!\n" ) ;
  die		( $myUsaj."\n")		;
}
#estfile not exists
if	(!-e $estfile)
{
  print	( STDERR "estfile file (".$estfile.") not exists!\n" ) ;
  die		( $myUsaj."\n")		;
}

#file opening for read
open	( DIR8FILE, "<".$in_file )		or		die ( "Cannot open  file: $in_file\n" ) ;
print	( STDERR "Reading file (".$in_file.")\n" )					;

#catching fields
my $i			=	0	;
while   ( $snpline=<DIR8FILE> )
{
  @dir8info	=	split (/\s/,$snpline)	;
  $snpid[$i]	=	$dir8info[0]	;
  $ctgid[$i]	=	$dir8info[2]	;
  $snplo[$i]	=	$dir8info[12]	;
  $snpnu[$i]	=	$dir8info[13]	;
  $snpca[$i]	=	$dir8info[14]	;
  $i++							;
}

#close the DIR8FILE file
close	( DIR8FILE )					or		die ( "Cannot close file: $in_file\n" ) ;

#file opening for read
open	( OUTFILE, ">".$outfile )		or		die ( "Cannot open  file: $outfile\n" ) ;
print	( STDERR "Writing file (".$outfile.")\n" )					;

$i				=	0	;
foreach (@ctgid)
{
  #file opening for read
  open	( READFILE, "<".$estfile )	or		die	( "Cannot open  file: $estfile\n" ) ;
  print	( STDERR "Reading file (".$estfile.")\n" )					;
  
  @readinfo		=	<READFILE>;
  chomp(@readinfo)				;
  
  #close the READFILE file
  close	( READFILE )				or		die ( "Cannot close file: $estfile\n" ) ;

  #fetch the contig in seqtabfile
  @readinfo		=	grep(/^$ctgid[$i]/,@readinfo)	;
  
  print ( OUTFILE $ctgid[$i]."\t".$snplo[$i]."\t".$snpid[$i]."\t".$snpnu[$i]."\t".$snpca[$i] )	;
  my	$countA = my $countC = my $countT = my $countG = my $countN = my $count_ = 0	;
  
  for ( my $j = 0 ; $j < @readinfo-1 ; $j++ )
  {
    @est_info	=	split(/\t/,$readinfo[$j])	;
    
    if ( $est_info[3] >= $snplo[$i] )
    {
      print ( OUTFILE "\t".$est_info[2] )	;
      
      for ( my $k = 0 ; $k < $est_info[7] ; $k++ )
      {
        @hit_info	=	split(/\s/,$est_info[8+$k]);
        
        if ( $snplo[$i] >= $hit_info[@hit_info-5] && $snplo[$i] <= $hit_info[@hit_info-4] )
        {
          if ( $hit_info[0] eq "+" )
          {
            $hit_lo	=	$snplo[$i]-$hit_info[@hit_info-5]+$hit_info[@hit_info-3]	;
          }
          else
          {
            $hit_lo	=	$snplo[$i]-$hit_info[@hit_info-5]+$hit_info[@hit_info-2]	;
          }
          
          #file opening for read
          open	( SEQ_FILE, "<".$seqfile )	or		die	( "Cannot open  file: $seqfile\n" ) ;
          print	( STDERR "Reading file (".$seqfile.")\n" )					;
          
          @dir8info	=	<SEQ_FILE>	;
          chomp(@dir8info)			;
          
          #close the SEQ_FILE file
          close	( SEQ_FILE )				or		die ( "Cannot close file: $seqfile\n" ) ;
          
          #fetch the contig in seqtabfile
          @dir8info	=	grep(/^$est_info[2]/,@dir8info)	;
          
          #catch the unique hit
          $snpline	=	$dir8info[0];
          
          #fetch seq list from seqtabfile
          @dir8info	=	split(/\s/,$snpline)	;
          $snpline	=	$dir8info[@dir8info-1];
          
          #fetch bp from list
          if	( $hit_lo > length($snpline) )
          {
            print	( STDERR "position out of read range\t".length($snpline)."<".$hit_lo."\n" )	;
            exit (0)				;
          }
          else
          {
            $hit_nu=	substr($snpline,$hit_lo-1,1)	;
            if ( $hit_nu eq "A" )
            {
              $countA++			;
            }
            elsif ( $hit_nu eq "C" )
            {
              $countC++			;
            }
            elsif ( $hit_nu eq "T" )
            {
              $countT++			;
            }
            elsif ( $hit_nu eq "G" )
            {
              $countG++			;
            }
            elsif ( $hit_nu eq "N" )
            {
              $countN++			;
            }
            else
            {
              $count_++			;
            }
          }

          #file opening for read
          open	( QUALFILE, "<".$quafile )	or		die	( "Cannot open  file: $quafile\n" ) ;
          print	( STDERR "Reading file (".$quafile.")\n" )					;
          
          @dir8info	=	<QUALFILE>	;
          chomp(@dir8info)			;
          
          #close the QUALFILE file
          close	( QUALFILE )				or		die ( "Cannot close file: $quafile\n" ) ;

          #fetch the contig in qualtabfile
          @dir8info	=	grep(/^$est_info[2]/,@dir8info)	;
          
          #catch the unique hit
          $snpline	=	$dir8info[0];
          
          #fetch qual list from qualtabfile
          @dir8info	=	split(/\s/,$snpline);
          $snpline	=	$dir8info[1];
          
          #fetch qual from list
          @dir8info	=	split(/,/,$snpline)	;
          if	( $hit_lo > @dir8info )
          {
            print	( STDERR "position out of read range\t".@dir8info."<".$hit_lo."\n" )	;
            exit (0)					;
          }
          else
          {
            $hit_ca	=	$dir8info[$hit_lo]	;
          }

          print ( OUTFILE "\t".$hit_lo." ".$hit_nu." ".$hit_ca );
        }
      }
    }
    $j++						;
  }
  print ( OUTFILE "\tA=".$countA.",C=".$countC.",T=".$countT.",G=".$countG.",N=".$countN.",-=".$count_ );
  print ( OUTFILE "\n" );
  $i++							;
}

#close the DIR8FILE file
close	( OUTFILE )						or		die ( "Cannot close file: $outfile\n" ) ;