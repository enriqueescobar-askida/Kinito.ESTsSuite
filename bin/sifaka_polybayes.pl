#!/usr/bin/perl -w

#uses
use diagnostics  ;
use strict       ;
use warnings     ;
use POSIX        ;
use Getopt::Long ;
use Carp         ;

#scalar vars
my  $siffile     ;
my  $pathclu     ;
my  $sifline     ;
my  $outfile     ;
my  $myUsaj   = "Usage: perl sifaka_polybayes.pl -s sifakafile -p path2clusters";
my  ($snpid,$snplo,$ctgid,$ctglo,$q_len,$h_len,$sign_,$q_str,$q_end,$h_str,$h_end,$encod) = 0;

#array vars
my  @sifinfo  = my @lininfo = ();

#hash vars
my  %HofSNP   = ();

#cmd line processing
Getopt::Long::Configure(  "bundling","no_ignore_case","require_order" );
GetOptions(   's=s' =>  \$siffile ,
              'p=s' =>  \$pathclu );

#checking command line options
#sifakafile not entered
if  ( !defined($siffile) or ($siffile eq "") )
{
  print ( STDERR "You haven t entered the sifaka_polybayesfile!\n" );
  die   ( $myUsaj."\n"  );
}
#sifakafile is a directory
if	(  -d  $siffile  )
{
  print ( STDERR "sifaka_polybayesfile file (".$siffile.") is a directory not a file!\n" );
  die   ( $myUsaj."\n"  );
}
#sifakafile not exists
if  ( !-e $siffile  )
{
  print ( STDERR "sifaka_polybayesfile file (".$siffile.") not exists!\n" );
  die   ( $myUsaj."\n"  );
}
#path2clusters not entered
if  ( !defined($pathclu) or ($pathclu eq "") )
{
  print ( STDERR "You haven t entered a path2clusters!\n" );
  die   ( $myUsaj."\n"  );
}

#file opening for read
open  ( SIFFILE, $siffile )   or    die ( "Cannot open  file : $siffile\n" );
print ( STDERR "Reading file (".$siffile.")\n" );

@sifinfo      = <SIFFILE>;
chomp ( @sifinfo  );

#close the SIFFILE file
close ( SIFFILE )             or    die ( "Cannot close file : $siffile\n" );

# parsing sifaka_polybayesfile
my  $i        = 0;
foreach ( @sifinfo  )
{
  $sifline    = $sifinfo[$i];

  #parsing line
  ($snpid,$snplo,$ctgid,$ctglo,$q_len,$h_len,$sign_,$q_str,$q_end,$h_str,$h_end,$encod)
              = split ( /\s/,$sifline );

  #deducing path
  my  ($clustr)=$ctgid =~ /^(.+)\.Contig[0-9]+$/;
  my  ($cludir)=$ctgid =~ /^([^.]+)\..+\..+/;
  my  ($ctgdir)=$clustr=~ /^(.+)\.[a-zA-Z][0-9]+_[a-zA-Z][0-9]+$/;
  $ctgdir     = $pathclu."/".substr($clustr,0,5)."/".$cludir."/".$clustr;
  my  $ctgsk  = $ctgdir."/".$clustr.".cap.contigs.seq.tab";
  my  $clusk  = $ctgdir."/".$clustr.".seq.tab";
  my  $cluql  = $ctgdir."/".$clustr.".qual.tab";
  my  $blast  = $ctgdir."/blast_contigs_ests";

  #parsing snp position in contig
  my  $h_nuc  = my $h_bla = "";
  my  $q_top  = 31-$q_str;
  my  $h_top  = ( $sign_ eq "+" ) ? $h_str+$q_top : $h_end-$q_top;
  $h_top      -=$h_str;

  #parsing encoding
  my  $count  = 0;
  my  $pos_q  = $q_str-1;
  my  $pos_h  = ( $sign_ eq "+" ) ? $h_str-1  : $h_end-1;
  my  $isz_h  = ( $sign_ eq "+" ) ? 1         : -1;
  my  @align  = $encod =~ /(\d+[a-zA-Z])/g;
  foreach my $chunk ( @align  )
  {
    my ($numbr,$lettr) = $chunk =~ /(\d+)([a-zA-Z])/;
    # Mismatch or N
    if ( $lettr =~ /[mn]/i )
    {
      for ( my $j = 0 ; $j < $numbr ; $j++ )
      {
        $pos_h+=$isz_h;
        if ( $count == $h_top )
        {
          $h_nuc  = "N";
#					$h_bla	=	&fetchBlastOutput($blast,$ctgid,($count+$h_str))	;
          $h_nuc  = $h_nuc." ".($count+$h_str);
          &fetchBlastOutput($blast,$ctgid,($count+$h_str),$clusk,$cluql);
        }
        $count++;
      }
    }
    # Identity
    else
    {
      for ( my $j = 0 ; $j < $numbr ; $j++ )
      {
        $pos_h+=$isz_h;
        if ( $count == $h_top )
        {
          $h_nuc  = &fetchContigSeqTab($ctgsk,$ctgid,($count+$h_str));
#					$h_bla	=	&fetchBlastOutput($blast,$ctgid,($count+$h_str));
          $h_nuc  = $h_nuc." ".($count+$h_str);
          &fetchBlastOutput($blast,$ctgid,($count+$h_str),$clusk,$cluql);
        }
        $count++;
      }
    }
  }

  $HofSNP{$snpid}->{$ctgid}	=	"$q_len\t$h_len\t$sign_\t$q_str\t$q_end\t$h_str\t$h_end\t$encod\t$h_nuc";
  print "$sifinfo[$i] $h_nuc,\n";
  $i++;
}

##########################################################################
##############################  subroutines     ##############################
##########################################################################

###
sub fetchContigSeqTab($$$)
###
{
  carp  "\twrong number of parameters != 3\n"
      unless  ( @_ == 3 );
  my  $str    = "undefined arg passed at:\t\t".__FILE__."\n\t\t";
  $str        .="\t\tat line\t".__FILE__."\n";
  croak "\t$str"
      unless  ( defined(@_) );
# local variables
  my  ($fil,$ctg,$pos)  = @_;
  my  $lin    = "";
  my  @info   = ();
# checking file
# not entered
  if  ( !defined($fil) or ($fil eq "") )
  {
    print ( STDERR "You haven t entered the file!\n" );
    die   ( $fil."\n" );
  }
# is a directory
  if  (  -d  $fil  )
  {
    print ( STDERR "file (".$fil.") is a directory not a file!\n" );
    die   ( $fil."\n" );
  }
# not exists
  if  (  !-e $fil  )
  {
    print ( STDERR "file (".$fil.") not exists!\n" );
    die   ( $fil."\n" );
  }
# file opening for read
  open  ( CTGFILE, $fil )    or     die ( "Cannot open  file : $fil\n" );
  print ( STDERR "Reading file (".$fil.")\n" );
  @info       = <CTGFILE>;
  chomp ( @info );
# close the CTGFILE file
  close ( CTGFILE )          or     die ( "Cannot close file : $fil\n" );
# fetching read
  ($lin)      = $ctg =~ /(Contig[0-9]+)$/;
  @info       = grep( /^$lin/,@info );
  $lin        = $info[@info-1];
  @info       = split(  /\s/,$lin );
  $lin        = $info[@info-1];
  return      substr( $lin,$pos-10,10 ).":".substr( $lin,$pos-1,1 );
}

###
sub fetchBlastOutput($$$$$)
###
{
  carp  "\twrong number of parameters != 5\n"
      unless  ( @_ == 5 );
  my  $str    = "undefined arg passed at:\t\t".__FILE__."\n\t\t";
  $str        .="\t\tat line\t".__FILE__."\n";
  croak "\t$str"
      unless  ( defined(@_) );
# local variables
  my  ($fil,$ctg,$pos,$cil,$cim)= @_;
  my  $lin    = "";
  my  @info=my @read=my @hits=();
# checking file
# not entered
  if  ( !defined($fil) or ($fil eq "") )
  {
    print ( STDERR "You haven t entered the file!\n" );
    die   ( $fil."\n" );
  }
# is a directory
  if  ( -d  $fil  )
  {
    print ( STDERR "file (".$fil.") is a directory not a file!\n" );
    die   ( $fil."\n");
  }
# not exists
  if  ( !-e $fil  )
  {
    print ( STDERR "file (".$fil.") not exists!\n" );
    die   ( $fil."\n");
  }
# not entered
  if  ( !defined($cil) or ($cil eq "") )
  {
    print ( STDERR "You haven t entered the file!\n" );
    die   ( $cil."\n" );
  }
# is a directory
  if  ( -d  $cil  )
  {
    print ( STDERR "file (".$cil.") is a directory not a file!\n" );
    die   ( $cil."\n" );
  }
# not exists
  if  ( !-e $cil  )
  {
    print ( STDERR "file (".$cil.") not exists!\n" );
    die   ( $cil."\n" );
  }
# not entered
  if  ( !defined($cim) or ($cim eq "") )
  {
    print ( STDERR "You haven t entered the file!\n" );
    die   ( $cim."\n" );
  }
# is a directory
  if  (-d  $cim)
  {
    print ( STDERR "file (".$cim.") is a directory not a file!\n" );
    die   ( $cim."\n" );
  }
# not exists
  if  (  !-e $cim  )
  {
    print ( STDERR "file (".$cim.") not exists!\n" );
    die   ( $cim."\n" );
  }
# file opening for read
  open  ( BLASTFILE, $fil )   or    die ( "Cannot open  file : $fil\n" );
  print ( STDERR "Reading file (".$fil.")\n" );
  @info       = <BLASTFILE>;
  chomp ( @info );
  @info       = grep( /^$ctg/,@info );
# close the BLASTFILE file
  close ( BLASTFILE )         or    die ( "Cannot close file : $fil\n" );
# fetching read
  foreach $lin ( @info )
  {
    @read     = split(  /\t/,$lin );
    if ( $read[3] >= $pos )
    {
      print ( STDOUT "\t".$read[2]."\t".$read[7]."\t" );
      for ( my $k = 0 ; $k < $read[7] ; $k++ )
      {
        @hits = split(  /\s/,$read[8+$k]  );
        my  $sg=$hits[0]  ;
        my  $qs=$hits[@hits-5];
        my  $qe=$hits[@hits-4];
        my  $hs=( $sg eq "+" ) ? $hits[@hits-3] : $hits[@hits-2];
        my  $he=( $sg eq "+" ) ? $hits[@hits-2] : $hits[@hits-3];
        my  $al=( $sg eq "+" ) ? $hits[@hits-1] : &revAlign($hits[@hits-1]);
        if ( $pos >= $hs && $pos <= $he )
        {
          print ( STDOUT $sg." ".$qs." ".$qe." ".$hs." ".$he." ".$al."==" );
          &findInBlastOut($cil,$cim,$read[2],$sg,$qs,$qe,$hs,$he,$al,$pos);
        }
      }
    }
    print ( STDOUT "\n" );
  }
# return        ;
}

###
sub revAlign($)
###
{
  carp  "\twrong number of parameters != 1\n"
      unless  ( @_ == 1 );
  my  $str    = "undefined arg passed at:\t\t".__FILE__."\n\t\t";
  $str        .="\t\tat line\t".__FILE__."\n";
  croak "\t$str"
      unless  ( defined(@_) );
# local variables
  my  ($line) = @_;
  my  $temp   = "";
  my  @alig   = $line =~ /(\d+[a-zA-Z])/g;
  for ( my $i = 0 ; $i < @alig ; $i++ )
  {
    $temp     = $alig[$i].$temp;
  }
  return      $temp;
}

###
sub findInBlastOut($$$$$$$$$$)
###
{
  carp  "\twrong number of parameters != 10\n"
      unless  ( @_ == 10 );
  my  $str    = "undefined arg passed at:\t\t".__FILE__."\n\t\t";
  $str        .="\t\tat line\t".__FILE__."\n";
  croak "\t$str"
      unless	( defined(@_) );
#	local variables
  my  ($csk,$cql,$ctg,$sg,$qs,$qe,$hs,$he,$sk,$lo)=	@_;
  my  @aln    = $sk =~ /(\d+[a-zA-Z])/g;
  my  $cnt    = my  $qnt=	1;
  my  $hnt    = $he;
  my  $top    = $hs+$lo-$qs;
  my  $tem    = 0;
  print ( "\n>$qs<$qe,$qe-$qs=".($qe-$qs)."\t$lo\t$hs<$he,$he-$hs=".($he-$hs)."\n" );
  print ( "($hs+$lo-$qs=$top)\n" );
  foreach my $tok ( @aln  )
  {
    my ($num,$let) = $tok =~ /(\d+)([a-zA-Z])/;
    $tem      +=$num;
#     # Mismatch
#     if (  $let =~ /m/i )
#     {
#       for ( my $i=0; $i < $num ; $i++ )
#       {
# #         print ( STDOUT $let );
#         if ( $cnt == $top )
#         {
#           print ( STDOUT "M=".$cnt."\t" );
#           &fetchClusterSeqTab($csk,$sg,$ctg,$cnt);
#           &fetchClusterQualTab($cql,$ctg,$cnt);
#         }
#         $cnt++;
#       }
#     }
#     # N
#     if (  $let =~ /n/i )
#     {
#       for ( my $i=0; $i < $num ; $i++ )
#       {
# #         print ( STDOUT $let );
#         if ( $cnt == $top )
#         {
#           print ( STDOUT "N=".$cnt."\t" );
#           &fetchClusterSeqTab($csk,$sg,$ctg,$cnt);
#           &fetchClusterQualTab($cql,$ctg,$cnt);
#         }
#         $cnt++;
#       }
#     }
#     # Gap on query
#     elsif ( $let eq "g" )
#     {
#       for ( my $i=0; $i < $num ; $i++ )
#       {
# #         print ( STDOUT $let );
#         if ( $cnt == $top )
#         {
#           print ( STDOUT "g=".$cnt."\t" );
#           &fetchClusterSeqTab($csk,$sg,$ctg,$cnt);
#           &fetchClusterQualTab($cql,$ctg,$cnt);
#         }
#         $cnt++;
#       }
#     }
#     # Gap on hit
#     elsif ( $let eq "G" )
#     {
#       for ( my $i=0; $i < $num ; $i++ )
#       {
# #         print ( STDOUT $let );
#         if ( $cnt == $top )
#         {
#           print ( STDOUT "G=".$cnt."\t" );
#           &fetchClusterSeqTab($csk,$sg,$ctg,$cnt);
#           &fetchClusterQualTab($cql,$ctg,$cnt);
#         }
# #         $cnt++;
#       }
#     }
#     # Identity
#     else
#     {
#       for ( my $i=0; $i < $num ; $i++ )
#       {
# #         print ( STDOUT $let );
#         if ( $cnt == $top )
#         {
#           print ( STDOUT "I=".$cnt."\t" );
#           &fetchClusterSeqTab($csk,$sg,$ctg,$cnt);
#           &fetchClusterQualTab($cql,$ctg,$cnt);
#         }
#         $cnt++;
#       }
#     }
  }
  print ( "/$tem" );
}

###
sub fetchClusterSeqTab($$$$)
###
{
  carp  "\twrong number of parameters != 4\n"
      unless  ( @_ == 4 );
  my  $str    = "undefined arg passed at:\t\t".__FILE__."\n\t\t";
  $str        .="\t\tat line\t".__FILE__."\n";
  croak "\t$str"
      unless  ( defined(@_) );
#	local variables
  my  ($fil,$sgn,$ctg,$pos) = @_;
  my  $lin    = "";
  my  @info   = ();
#	checking file
#	not entered
  if  ( !defined($fil) or ($fil eq "") )
  {
    print ( STDERR "You haven t entered the file!\n" );
    die   ( $fil."\n" );
  }
#	is a directory
  if  ( -d  $fil  )
  {
    print ( STDERR "file (".$fil.") is a directory not a file!\n" );
    die   ( $fil."\n" );
  }
#	not exists
  if  ( !-e $fil )
  {
    print ( STDERR "file (".$fil.") not exists!\n" );
    die   ( $fil."\n" );
  }
#	file opening for read
  open  ( CLUSTFILE, $fil )   or    die ( "Cannot open  file : $fil\n" );
  print ( STDERR "Reading file (".$fil.")\n" );
  @info       = <CLUSTFILE>;
  chomp ( @info );
  @info       = grep( /^$ctg/,@info );
#	close the CLUSTFILE file
  close ( CLUSTFILE )         or    die ( "Cannot close file : $fil\n" );
#	fetching read
  $lin        = $info[@info-1];
  @info       = split(  /\s/,$lin );
  $lin        = $info[@info-1];
  if ( $sgn eq "-" )
  {
    $lin  = scalar reverse($info[@info-1]);
    $lin  =~  tr/ACGTacgt/TGCAtgca/;
  }
  $lin        = substr( $lin,$pos-20,20 );
  print ( STDOUT "\n$lin\n" );
}

###
sub fetchClusterQualTab($$$)
###
{
  carp	"\twrong number of parameters != 3\n"
      unless  ( @_ == 3 );
  my  $str    = "undefined arg passed at:\t\t".__FILE__."\n\t\t";
  $str        .="\t\tat line\t".__FILE__."\n";
  croak "\t$str"
      unless  ( defined(@_) );
#	local variables
  my  ($fil,$ctg,$pos)  = @_;
  my  $lin    = "";
  my  @info   = ();
#	checking file
#	not entered
  if	( !defined($fil) or ($fil eq "") )
  {
    print ( STDERR "You haven t entered the file!\n" );
    die   ( $fil."\n" );
  }
#	is a directory
  if	(  -d  $fil  )
  {
    print ( STDERR "file (".$fil.") is a directory not a file!\n" );
    die   ( $fil."\n" );
  }
#	not exists
  if  ( !-e $fil)
  {
    print ( STDERR "file (".$fil.") not exists!\n" );
    die   ( $fil."\n" );
  }
#	file opening for read
  open  ( CLUSTFILE, $fil )   or    die ( "Cannot open  file : $fil\n" );
  print ( STDERR "Reading file (".$fil.")\n" );
  @info       = <CLUSTFILE>;
  chomp ( @info );
#	close the CLUSTFILE file
  close ( CLUSTFILE )         or    die ( "Cannot close file : $fil\n" );
#	fetch the contig in qualtabfile
  @info       = grep( /^$ctg/,@info );
#	catch the unique hit
  $lin        = $info[0];
#	fetch qual list from qualtabfile
  @info       = split(  /\s/,$lin );
  $lin        = $info[1];
#	fetch qual from list
  @info       = split(  /,/,$lin  );
  $lin        = $info[$pos];
  print ( STDOUT $lin."\n" );
}
