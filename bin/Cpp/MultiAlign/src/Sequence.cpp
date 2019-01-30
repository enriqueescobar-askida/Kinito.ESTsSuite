#include	"Sequence.hpp"
#include	"GenetiCode.hpp"
#include	<cassert>
#include	<boost/regex.hpp>

using		namespace std;
//constructor of (seq), (DNA), (sens), (qlt)
Sequence::Sequence()
	:
	aSequence( "GATTACA" ),
	aSeqType( DNA ),
	aSeqSens( plus ),
	aSeqQual( ""),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, (DNA), (sens), (qlt)
Sequence::Sequence( const string& str )
	:
	aSequence( str ),
	aSeqType( DNA ),
	aSeqSens( plus ),
	aSeqQual( ""),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, DNA, (sens), (qlt)
Sequence::Sequence( const string& str, SeqType typ )
	:
	aSequence( str ),
	aSeqType( typ ),
	aSeqSens( plus ),
	aSeqQual( ""),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, (DNA), sens, (qlt)
Sequence::Sequence( const string& str, SeqSens sen )
	:
	aSequence( str ),
	aSeqType( DNA ),
	aSeqSens( sen ),
	aSeqQual( ""),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, (DNA), (sens), qlt
Sequence::Sequence( const std::string& str, const std::string& qlt )
	:
	aSequence( str ),
	aSeqType( DNA ),
	aSeqSens( plus ),
	aSeqQual( qlt ),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, DNA, sens, (qlt)
Sequence::Sequence( const std::string& str, SeqType typ, SeqSens sen )
	:
	aSequence( str ),
	aSeqType( typ ),
	aSeqSens( sen ),
	aSeqQual( ""),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, DNA, (sens), qlt
Sequence::Sequence( const std::string& str, SeqType typ, const std::string& qlt )
	:
	aSequence( str ),
	aSeqType( typ ),
	aSeqSens( plus ),
	aSeqQual( qlt ),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, (DNA), sens, qlt
Sequence::Sequence( const std::string& str, SeqSens sen, const std::string& qlt )
	:
	aSequence( str ),
	aSeqType( DNA ),
	aSeqSens( sen ),
	aSeqQual( qlt ),
	aSeqEncod( "" )
{
	IUPAC();
}
//constructor of seq, DNA, sens, qlt
Sequence::Sequence( const std::string& str, SeqType typ, SeqSens sen, const std::string& qlt )
	:
	aSequence( str ),
	aSeqType( typ ),
	aSeqSens( sen ),
	aSeqQual( qlt ),
	aSeqEncod( "" )
{
	IUPAC();
}
//destructor
Sequence::~Sequence()
{
}

/** A method to get the depth
@return	int		an integer of depth
*/
int				Sequence::length() const
{
	return			aSequence.length();
}

/** A method to get the complement
@return	string	a string of the complement in same orientation
*/
std::string		Sequence::complement()
{
	string	tempStr	=	compRF( 0 );
	return			tempStr;
}

/** A method to get the transcript
@return	string	a string of the transcript in same orientation
*/
std::string		Sequence::transcribe()
{
	if ( aSeqType == DNA )
		return		boost::regex_replace( aSequence, boost::regex("[tT]"), "u" );
	else
		return		aSequence;
}

/** A method to get the translation
@return	string	a string of the translation in same orientation
*/
std::string		Sequence::translate()
{
	string	aProt	=	"";
	int	nbCodons	=	aSequence.length()/3;
	
	for ( int i = 0 ; i < nbCodons ; i++ )
		aProt+=GenetiCode::find( aSequence.substr( 3*i, 3 ) );
	
	return			aProt;
}

/** A method to get the translation starting at
@param	int		an int position inside the string
@return	string	a string of the translation in same orientation starting at
*/
std::string		Sequence::translate( unsigned int bp )
{
	if ( bp < 0 || bp >= aSequence.length() )
		return		"";
	else
	{
		string	aSeq	=	aSequence.substr( bp, aSequence.length() );
		string	aProt	=	"";
		int	nbCodons	=	aSeq.length()/3;
		
		for ( int i = 0 ; i < nbCodons ; i++ )
			aProt+=GenetiCode::find( aSeq.substr( 3*i, 3 ) );
		
		return		aProt;
	}
}

/** A method to get the first reading frame
@return	string	a string of the first reading frame in same orientation
*/
std::string		Sequence::RF0()
{
	string	str		=	RF( 0 );
	return			str;
}

/** A method to get the second reading frame
@return	string	a string of the second reading frame in same orientation
*/
std::string		Sequence::RF1()
{
	string	str		=	RF( 1 );
	return			str;
}

/** A method to get the third reading frame
@return	string	a string of the third reading frame in same orientation
*/
std::string		Sequence::RF2()
{
	string	str		=	RF( 2 );
	return			str;
}

/** A method to get the complement of the first reading frame
@return	string	a string of the complement of the first reading frame in same orientation
*/
std::string		Sequence::compRF0()
{
	string	str		=	compRF( 0 );
	return			str;
}

/** A method to get the complement of the second reading frame
@return	string	a string of the complement of the second reading frame in same orientation
*/
std::string		Sequence::compRF1()
{
	string	str		=	compRF( 1 );
	return			str;
}

/** A method to get the complement of the third reading frame
@return	string	a string of the complement of the third reading frame in same orientation
*/
std::string		Sequence::compRF2()
{
	string	str		=	compRF( 2 );
	return			str;
}

/** A method to get the reverse
@return	string	a string of the reverse in same orientation
*/
std::string		Sequence::reverse()
{
	string			tempStr;
	for ( unsigned int i = 0 ; i < aSequence.length() ; i++ )
	{
		tempStr+=aSequence.substr(aSequence.length()-i-1,1);
	}
	return			tempStr;
}
	
/** A method to get the indexes of ORFs
@return	vector<string>	a vector of indexes of ORFs in same orientation
*/
std::vector<string>	Sequence::ORFs()
{
	string	start	=	"atg";
	size_t	posSt	=	0;
	vector<string>	v;
	
	posSt			=	aSequence.find( start, 0 );
	if ( posSt == string::npos )
	{
		return		v;
	}
	else
	{
		while ( posSt != string::npos )
		{
			v.push_back( aSequence.substr( posSt, aSequence.length() ) );
			posSt		=	aSequence.find( start, posSt+1 );
		}
		return			v;
	}
}

/** A method to remove non IUPAC residues
@return	string	a string of the IUPAC residues in same orientation
*/
void			Sequence::IUPAC()
{
	if ( aSeqType == DNA )
	{
		aSequence	=	boost::regex_replace( aSequence, boost::regex("[eEfFiIjJlLoOpPqQzZxX*!?,;.:' ]"), "-" );
		aSequence	=	boost::regex_replace( aSequence, boost::regex( "(.*)" ), "\\L$1" );
	}
	if ( aSeqType == RNA )
	{
		aSequence	=	boost::regex_replace( aSequence, boost::regex("[eEfFiIjJlLoOpPqQzZxX*!?,;.:' ]"), "-" );
		aSequence	=	boost::regex_replace( aSequence, boost::regex("[T]"), "U" );
		aSequence	=	boost::regex_replace( aSequence, boost::regex("[t]"), "u" );
		aSequence	=	boost::regex_replace( aSequence, boost::regex( "(.*)" ), "\\L$1" );
	}
	if ( aSeqType == AA )
		aSequence	=	boost::regex_replace( aSequence, boost::regex("[jJoO!?,;.:' ]"), "-" );
}

/** A method to get this reading frame
@param	int		an int position inside the string
@return	string	a string of this reading frame in same orientation
*/
std::string		Sequence::RF( unsigned int bp )
{
	if ( bp < 0 || bp >= aSequence.length() )
		return		"";
	else
	{
		string	str	=	aSequence.substr( bp, aSequence.length() );
		return		str;
	}
}

/** A method to get this reading frame s complement
@param	int		an int position inside the string
@return	string	a string of this reading frame in same orientation
*/
std::string		Sequence::compRF( unsigned int bp )
{
	if ( bp < 0 || bp >= aSequence.length() )
		return		"";
	else
	{
		string	tempStr, str;
		str			=	reverse();
		str			=	str.substr( 0, str.length()-bp );
		for ( unsigned int i = 0 ; i < str.length() ; i++ )
		{
			if ( str[i]=='A' )
				tempStr+="T";
			else if ( str[i]=='a' )
				tempStr+="t";
			else if ( str[i]=='C' )
				tempStr+="G";
			else if ( str[i]=='c' )
				tempStr+="g";
			else if ( str[i]=='G' )
				tempStr+="C";
			else if ( str[i]=='g' )
				tempStr+="c";
			else if ( str[i]=='T' )
				tempStr+="A";
			else if ( str[i]=='t' )
				tempStr+="a";
			
			else if ( str[i]=='U' )
				tempStr+="A";
			else if ( str[i]=='u' )
				tempStr+="a";
			
			else if ( str[i]=='R' )
				tempStr+="Y";
			else if ( str[i]=='r' )
				tempStr+="y";
			else if ( str[i]=='Y' )
				tempStr+="R";
			else if ( str[i]=='y' )
				tempStr+="r";
			
			else if ( str[i]=='K' )
				tempStr+="M";
			else if ( str[i]=='k' )
				tempStr+="m";
			else if ( str[i]=='M' )
				tempStr+="K";
			else if ( str[i]=='m' )
				tempStr+="k";
			
			else if ( str[i]=='S' )
				tempStr+="W";
			else if ( str[i]=='s' )
				tempStr+="w";
			else if ( str[i]=='W' )
				tempStr+="S";
			else if ( str[i]=='w' )
				tempStr+="s";
			else
				tempStr+=str.substr(i,1);
		}
		return		tempStr;
	}
}

