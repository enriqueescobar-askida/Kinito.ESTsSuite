=pod

=head1 NAME

eescobar::ContigReader - Perl extension for ESTs contigs.

=cut

=head1 SYNOPSIS

  This program's purpose is to read contig.seq.tab.

# Change this line to show the folder where you store ContigReader.pm
  use constant  PERLELIB => $ENV{"PERLELIB"}  ;
  use lib PERLELIB;
  use eescobar::ContigReader;

#uses
  use   5.007   ;
#our(@ISA,@EXPORT,$VERSION,$MAJOR,$MINOR,$PATCH)
  use vars        qw(@ISA @EXPORT $VERSION $MAJOR $MINOR $PATCH)  ;
  use   diagnostics ;
  use   strict    ;
  use   warnings  ;
  use   diagnostics ;
  use   Carp    ;
  use   Config    ;

#variables

#methods
  fetchCTGSeqTab  (I<$fil,$ctg>)  return  string representing contig.seq.tab sequence
  fetchCTGSeqTabAt (I<$fil,$ctg,$pos>)  return  string representing contig.seq.tab base pair

=cut

=head1 PRECOND

This program uses specific programs: perl fasta2line.pl

=cut
package eescobar::ContigReader;

use 5.007;
use strict;
use warnings;
use diagnostics;

#debug use
use Carp;
#my use
use Config;

=head1 REQUIRES

The REQUIRES section tells the user what they will need in order to use the module.

Exporter

Packages allow a program to be partitioned into separate namespaces. However, this leads immediately to the problem of how one package may access the facilities of another.

#array of inheritance table to avoid $object->Class::method()

our @ISA      = qw(Exporter);

=cut

#std export use
require Exporter;
# use AutoLoader qw(AUTOLOAD);

#array of inheritance table to avoid $object->Class::method()
our @ISA  = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration use eescobar::SysCall ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.

#hash containing a series of import sets
# ('standard' =>  [Process, Regurgitate],
# 'Processing'  =>  [Process, Parse]);
our %EXPORT_TAGS  = ( 'all' => [ qw(
                  ) ] );

#array of ospecific bjects not exported from the module if specifically requested even with the prefix
our @EXPORT_FAIL  = ( @{ $EXPORT_TAGS{'all'} } );

#array of specific objects exported from the module if specifically requested
our @EXPORT_OK    = ( @{ $EXPORT_TAGS{'all'} } );

=head1 EXPORTS

The EXPORTS section tells the user what the module will do to their namespace if they use it.

our @EXPORT     = qw  (fetchCTGSeqTab,fetchCTGSeqTabAt)  ;

=cut

our @EXPORT     = qw  (
              fetchCTGSeqTab
              fetchCTGSeqTabAt
              ) ;

=head1 DESCRIPTION

Stub documentation for eescobar::ContigReader, created by h2xs.

ContigReader.pm   a program that calls celutil.

# Change this line to show the folder where you store System.pm
use constant  PERLELIB => "/opt/Suite/ESTsSuite/trunk/lib/perl/eescobar-ContigReader/lib"  ;
use lib PERLELIB;
use eescobar::ContigReader;

contig.seq.tab reader :  fetchCTGSeqTab($fil,$ctg), fetchCTGSeqTabAt($fil,$ctg,$pos)

=cut

=head1 OPTIONS

This is module uses no options or arguments.

=cut

=head1 RETURN

This is module return strings.

=cut

=head1 ERRORS

This is module verifies only the number of arguments passed to its methods and it verifies if they are defined. If you inverted the variables passed in arguments you may have surprises.

=cut

=head1 ENVIRONMENT

This is module uses these global variables:

constant PERLELIB @ISA @EXPORT $VERSION $MAJOR $MINOR $PATCH $TRUE $FALSE

=cut

=head1 FILES

This is module uses files and paths passed in argument.

=cut

=head1 VERSION

This is module version is B<0.1>.

=cut

=head1 SINCE

This is module was created the B<18/05/2007>.

=cut

=head1 GLOBAL VARIABLES

The GLOBAL VARIABLES section lists any package variables in the API.

constant PERLELIB %EXPORT_TAGS @ISA @EXPORT_FAIL @EXPORT_OK @EXPORT $VERSION $MAJOR $MINOR $PATCH $TRUE $FALSE

=cut

our $VERSION    = '0.1' ;
our $MAJOR      = '0'   ;
our $MINOR      = '0'   ;
our $PATCH      = '0'   ;

#visibility of requires, methods & version
#our(@ISA,@EXPORT,$VERSION,$MAJOR,$MINOR,$PATCH)
use vars        qw(@ISA @EXPORT $VERSION $MAJOR $MINOR $PATCH)  ;

=head1 DIAGNOSTICS

Errors/ messages & their means, in this DIAGNOSTICS section, a text of every error message the the module may generate, and explains its meaning. Error messages are classified as follows: (W) A warning (optional), (D) A deprecation (optional), (S) A severe warning (mandatory), (F) A fatal error (trappable), (X) A very fatal error (non-trappable). In this case we only provided the module file name and the line number in the module.

=cut

=head1 BUGS

This is module has bugs as any program, suggestions are welcome for the next version.

=cut

=head1 RESTRICTIONS

This is module uses fasta2line.pl it may not work in windows, it may work in OSX.

=cut

=head1 HISTORY

This is module uses fasta2line.pl.

=cut

##########################################################################
##############################  subroutines     ##############################
##########################################################################

=head1 METHODS

The METHODS section lists and describes each method in the class.

=cut

# Preloaded methods go here.

##############################
########## sub fetchCTGSeqTab

=head2 fetchCTGSeqTab (I<$fil,$ctg>)

This method receives a contig filehandle to verify its sequence.

=over 4

=item @precond

fasta2line.pl must be used to create a contig.seq.tab file

=item @param  I<$fil>

a string representing a contig.seq.tab filehandle

=item @return I<$ctg>

a string representing a contig

=back

=cut

###
sub fetchCTGSeqTab($$)
###
{
  carp  "\twrong number of parameters!= 2\n"  unless  ( @_ == 2 ) ;
  croak "\tundefined string passed at:\t\tpackage\teescobar::substr(__FILE__,-3)substr(__FILE__,-3)\n\t\t-module\t__FILE__\n\t\t-sub\tfetchCTGSeqTabAt\n\t\t-line\t__LINE__\n" unless  ( defined(@_) )  ;
# local variables
  my  ($fil,$ctg)  = @_;
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
#   print ( STDERR "Reading file (".$fil.")\n" );
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
#   return      substr( $lin,$pos-10,10 ).":".substr( $lin,$pos-1,1 );
  if (  length($lin) > 0  )
  {
    return      $lin;
  }
  else
  {
    return      "";
  }
}
########## sub fetchCTGSeqTab
##############################

##############################
########## sub fetchCTGSeqTabAt

=head2  fetchCTGSeqTabAt (I<$fil,$ctg,$pos>)

This method receives a contig filehandle to verify its sequence.

=over 4

=item @precond

fasta2line.pl must be used to create a contig.seq.tab file

=item @param  I<$fil>

a string representing a contig.seq.tab filehandle

=item @return I<$ctg>

a string representing a contig

=item @return I<$pos>

a string representing a position

=back

=cut

###
sub fetchCTGSeqTabAt($$$)
###
{
  carp  "\twrong number of parameters!= 3\n"  unless  ( @_ == 3 ) ;
  croak "\tundefined string passed at:\t\tpackage\teescobar::substr(__FILE__,-3)substr(__FILE__,-3)\n\t\t-module\t__FILE__\n\t\t-sub\tfetchCTGSeqTabAt\n\t\t-line\t__LINE__\n" unless  ( defined(@_) )  ;
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
#   print ( STDERR "Reading file (".$fil.")\n" );
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
#   return      substr( $lin,$pos-10,10 ).":".substr( $lin,$pos-1,1 );
  if (  $pos >= 0 || $pos < length($lin)  )
  {
    return      substr( $lin,$pos-1,1 );
  }
  else
  {
    return      "n";
  }
}
########## sub fetchCTGSeqTabAt
##############################

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 SEE ALSO

If you have a web site set up for your module, mention it here.

B<Quique's web page> for more information http://adn.bioinfo.uqam.ca/~escd07097301/

perl(1), fasta2line.pl

=cut

=head1 AUTHOR

Enrique ESCOBAR, E<lt>enrique.escobar@genome.ulaval.caE<gt>

=head1 EXAMPLES

#testing methods
# Change this line to show the folder where you store System.pm
  use constant  PERLELIB => "/home/eescobar/PerlCode/eescobar-ContigReader/lib"  ;

  use lib PERLELIB;
  use eescobar::ContigReader;

#tests
  my $mycelfile=  "CEL_norm___BZ2norm.CEL";
  print ( "do celutil <$mycelfile>\t" );
  print ( &fetchCTGSeqTab($mycelfile)."\n" );

  $mycelfile  = "CEL_norm___BZ2norm.CEL.gz";
  print ( "do celutil <$mycelfile>\t" );
  print ( &fetchCTGSeqTab($mycelfile)."\n" );

  $mycelfile  = "CEL_norm___BZ2norm.CEL.bz2";
  print ( "do celutil <$mycelfile>\t" );
  print ( &fetchCTGSeqTab($mycelfile)."\n" );

=head1 MODIF

B<Enrique Escobar> @ Quebec Genomic Centre 18/05/2007

=head1 NOTES

This programs needs your cool routines.

=head1  CAVEATS/WARNINGS

In this program you should be Aware of non verification of each argument passed.

=head1 SEE CODE

B<ContigReader.pm @ Quique's web page> for more information http://adn.bioinfo.uqam.ca/~escd07097301/

=begin html

<a href="http://adn.bioinfo.uqam.ca/~escd07097301/mycode/PerlCode/eescobar/ContigReader.html">ContigReader.pm</a>

=end html

=head1 COPYRIGHT AND LICENSE

This script is distributed under the GNU General Public License
version 2.1 or later. See http://www.fsf.org/

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2.1, or (at your option)
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License can be obtained from this
program's author (send electronic mail to the above address) or from
Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
or from the Free Software Foundation website: http://www.fsf.org/

=cut
