#ifndef		EDDIST_HPP
#define		EDDIST_HPP
#include	<vector>
#include	<string>

/** @class EdDist EdDist.hpp Package/EdDist.hpp

	Class allowing to calculate edition distance between sequence strings

	@author Enrique Escobar
	@date	27/02/2007
*/

class	EdDist
{
public:
	//constructor of str1, str2
	EdDist( const std::string& str1, const std::string& str2 );
	//destructor
	~EdDist();
	
private:
	int								aCost;
	int								aDist;
	std::string						aSeq1;
	std::string						aSeq2;
	std::string						align1;
	std::string						align2;
	std::string						op1to2;
	std::vector< std::vector<int> >	aVect;
	
	/** A method to get the min
    @return	int		a min integer
	*/
	int				min( int inti, int intj )	const;
	
	/** A method to get the isHmin
    @return	bool	a boolean if is min or not between D and V
	*/
	bool			isHmin( int inti, int intj )	const;
	
	/** A method to get the isDmin
    @return	bool	a boolean if is min or not between H and V
	*/
	bool			isDmin( int inti, int intj )	const;
	
	/** A method to get the isVmin
    @return	bool	a boolean if is min or not between D and H
	*/
	bool			isVmin( int inti, int intj )	const;
	
public:
	/** A method to get the edition distance
    @return	int		an integer of edition distance
	*/
	int				getDistance()	;

	/** A method to print edition distance matrix
	*/
	void			print();

	/** A method to print edition distance matrix in a file
	*/
	void			print( const std::string& str );
	
	/** A method to align sequences with edition distance matrix
	*/
	void			Align();
	
	/** A method to print aligned sequences with edition distance matrix
	*/
	void			printAlign();
	
	/** A method to print operations to pass from seq2seq with edition distance matrix
	*/
	void			printOps();
};

#endif
	
