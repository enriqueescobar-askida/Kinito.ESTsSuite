#ifndef		SEQUENCE_HPP
#define		SEQUENCE_HPP
#include	<string>
#include	<vector>

 /** @class Sequence Sequence.hpp Package/Sequence.hpp

    Class allowing to manipulate sequence strings
 
    @author Enrique Escobar
    @date	27/02/2007
*/

class	Sequence
{
private:
	enum	SeqType	{ DNA, RNA, AA };
	enum	SeqSens	{ plus, minus };
	
public:
	//constructor of (seq), (DNA), (sens), (qlt)
	Sequence();
	//constructor of seq, (DNA), (sens), (qlt)
	Sequence( const std::string& str );
	//constructor of seq, DNA, (sens), (qlt)
	Sequence( const std::string& str, SeqType typ );
	//constructor of seq, (DNA), sens, (qlt)
	Sequence( const std::string& str, SeqSens sen );
	//constructor of seq, (DNA), (sens), qlt
	Sequence( const std::string& str, const std::string& qlt );
	//constructor of seq, DNA, sens, (qlt)
	Sequence( const std::string& str, SeqType typ, SeqSens sen );
	//constructor of seq, DNA, (sens), qlt
	Sequence( const std::string& str, SeqType typ, const std::string& qlt );
	//constructor of seq, (DNA), sens, qlt
	Sequence( const std::string& str, SeqSens sen, const std::string& qlt );
	//constructor of seq, DNA, sens, qlt
	Sequence( const std::string& str, SeqType typ, SeqSens sen, const std::string& qlt );
	//destructor
	~Sequence();

	/** A method to get the depth
    @return	int		an integer of depth
	*/
	int				length()	const;

	/** A method to get the complement
    @return	string	a string of the complement in same orientation
	*/
	std::string		complement();
	
	/** A method to get the transcript
    @return	string	a string of the transcript in same orientation
	*/
	std::string		transcribe();
	
	/** A method to get the translation
    @return	string	a string of the translation in same orientation
	*/
	std::string		translate();
	
	/** A method to get the translation starting at
	@param	int		an int position inside the string
    @return	string	a string of the translation in same orientation starting at
	*/
	std::string		translate( unsigned int bp );
	
	/** A method to get the first reading frame
    @return	string	a string of the first reading frame in same orientation
	*/
	std::string		RF0();
	
	/** A method to get the second reading frame
    @return	string	a string of the second reading frame in same orientation
	*/
	std::string		RF1();
	
	/** A method to get the third reading frame
    @return	string	a string of the third reading frame in same orientation
	*/
	std::string		RF2();
	
	/** A method to get the complement of the first reading frame
    @return	string	a string of the complement of the first reading frame in same orientation
	*/
	std::string		compRF0();
	
	/** A method to get the complement of the second reading frame
    @return	string	a string of the complement of the second reading frame in same orientation
	*/
	std::string		compRF1();
	
	/** A method to get the complement of the third reading frame
    @return	string	a string of the complement of the third reading frame in same orientation
	*/
	std::string		compRF2();
	
	/** A method to get the reverse
    @return	string	a string of the reverse in same orientation
	*/
	std::string		reverse();
	
	/** A method to get the indexes of ORFs
    @return	vector<string>	a vector of indexes of ORFs in same orientation
	*/
	std::vector<std::string>	ORFs();
	
	/** A method to remove non IUPAC residues
    @return	string	a string of the IUPAC residues in same orientation
	*/
	void			IUPAC();


private:
	std::string		aSequence;
	SeqType			aSeqType;
	SeqSens			aSeqSens;
	std::string		aSeqQual;
	std::string		aSeqEncod;
	
	/** A method to get the complement of this reading frame
	@param	int		an int position inside the string
    @return	string	a string of the complement of this reading frame in same orientation
	*/
	std::string		RF( unsigned int bp );
	
	/** A method to get the complement of this reading frame
	@param	int		an int position inside the string
    @return	string	a string of the complement of this reading frame in same orientation
	*/
	std::string		compRF( unsigned int bp );
};

#endif

