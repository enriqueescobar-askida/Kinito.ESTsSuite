#ifndef		GENETICODE_HPP
#define		GENETICODE_HPP
#include	<iostream>
#include	<fstream>
#include	<string>
#include	<map>

 /** @class GenetiCode GenetiCode.hpp Package/GenetiCode.hpp

    Class allowing to translate strings
 
    @author Enrique Escobar
    @date	27/02/2007
*/

class	GenetiCode
{
	
public:
	//constructor
	GenetiCode(){};
	//destructor
	~GenetiCode(){};

	
private:
	typedef	std::map<std::string,std::string>	Map;
	static Map			codon2aaMap;
	
	static bool			isFilled;
	
	static void		loadMap()
	{
		std::ifstream		input_Stream( "GENETICODE", std::ios::in  );
		std::string			aStr;
		while ( input_Stream.good() )
		{
			getline( input_Stream, aStr );
			if( ! input_Stream.eof() )
			{
				codon2aaMap[ aStr.substr(0,3) ]	=	aStr.substr(4,1);
			}
			else
			{
				break;
			}
		}
		input_Stream.close();
	}
	
public:
	static	std::string	find( const std::string& str )
	{
		if ( !isFilled )
		{
			loadMap();
			isFilled=	true;
		}
		Map::iterator	mapIter = codon2aaMap.find( str );
		if ( mapIter==codon2aaMap.end() )
			return		"-";
		else
			return		mapIter->second;
	}
//	static	GenetiCode codon2aaMap;

};

#endif

