#include	"EdDist.hpp"
#include	<iostream>	//std io
#include	<cassert>
#include	<boost/regex.hpp>
#include	<fstream>	//file io
#include	<math.h>


using		namespace std;
//constructor of str1, str2
EdDist::EdDist( const string& str1, const string& str2 )
	:
	aSeq1( str1 ),
	aSeq2( str2 )
{
	align1	=	"";
	align2	=	"";
	op1to2	=	"";
	aCost	=	1;
	aVect.assign( aSeq1.length(), vector<int> ( aSeq2.length(), 0) );
}
//destructor
EdDist::~EdDist()
{
}

/** A method to get the edition distance
@return	int		an integer of edition distance
*/
int				EdDist::getDistance()	
{
	int		k	=	0;

	for ( unsigned i = 0 ; i < aSeq1.length() ; i++ )
	{
		for ( unsigned j = 0 ; j < aSeq2.length() ; j++ )
		{
			k	=	!( aSeq1[i]==aSeq2[j] );
			if ( i==0 && j==0 )
				aVect[i][j]	=	k;
			else if ( i==0 && j!=0 )
				aVect[i][j]	=	min( j+k, min( j+2, aVect[i][j-1]+1 ) );
			else if ( i!=0 && j==0 )
				aVect[i][j]	=	min( i+k, min( aVect[i-1][j]+1, i+2 ) );
			else
				aVect[i][j]	=	min( aVect[i-1][j-1]+k, min( aVect[i-1][j]+1, aVect[i][j-1]+1 ) );
		}
	}
	return		aVect[aSeq1.length()-1][aSeq2.length()-1];
}

/** A method to print of edition distance matrix
*/
void			EdDist::print()
{
	cout << "  ";
	for ( unsigned i = 0 ; i < aSeq1.length() ; i++ )
	{
		if ( i != aSeq1.length()-1 )
			cout << aSeq1[i] << " ";
		else
			cout << aSeq1[i] << "\n";
	}
	
	for ( unsigned j = 0 ; j < aSeq2.length() ; j++ )
	{
		cout << aSeq2[j] << " ";
		for ( unsigned i = 0 ; i < aSeq1.length() ; i++ )
		{
			if ( i != aSeq1.length()-1 )
				cout << aVect[i][j] << " ";
			else
				cout << aVect[i][j];
		}
		cout << "\n";
	}
}

/** A method to print of edition distance matrix to a file
*/
void			EdDist::print( const string& str )
{
	ofstream			outputStream( str.c_str(), ios::out );
	if ( outputStream.fail() )
	{
		cerr			<< "Cannot open file" << str << endl;
	}

	for ( unsigned j = 0 ; j < aSeq2.length() ; j++ )
	{
		for ( unsigned i = 0 ; i < aSeq1.length() ; i++ )
		{
			if ( i != aSeq1.length()-1 )
				outputStream << aVect[i][j] << " ";
			else
				outputStream << aVect[i][j];
		}
		outputStream << "\n";
	}
}

/** A method to align sequences with edition distance matrix
*/
void			EdDist::Align()
{
	int		i	=	aSeq1.length()-1;
	int		j	=	aSeq2.length()-1;
	int		v	=	0;
	bool	H	=	false;
	bool	V	=	false;
	bool	D	=	false;
	string	s1	=	"";
	string	s2	=	"";

	while ( i > 0 || j > 0 )
	{
		H		=	( aVect[i][j]	==	aVect[i-1][j] +1) && isHmin(i-1,j);
		V		=	( aVect[i][j]	==	aVect[i][j-1] +1) && isVmin(i,j-1);
		D		=	( aVect[i][j]	==	aVect[i-1][j-1]	) && isDmin(i-1,j-1);
		v		=	aVect[i][j];
		
//		diago
		if ( i > 0 && j > 0 && D )
		{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\ta\n";
			s1=aSeq1.substr(i,1)+s1;
			s2=aSeq2.substr(j,1)+s2;
			i--;
			j--;
			if ( i == 0 && j == 0 )
			{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\ta1\n";
				s1=aSeq1.substr(i,1)+s1;
				s2=aSeq2.substr(j,1)+s2;
			}
			else if ( i == 0 && j > 0 )
			{
				cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\ta2\n";
				s1=aSeq1.substr(i,1)+s1;
				s2=aSeq2.substr(j,1)+s2;
				while ( j > 0 )
				{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\ta-\n";
					s1="-"+s1;
					j--;
					s2=aSeq2.substr(j,1)+s2;
				}
			}
			else if ( i == 0 && j > 0 &&
					aSeq1.substr(i,1)!=aSeq2.substr(j,1) && aSeq1.substr(i,1)==aSeq2.substr(j-1,1) )
			{
				cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\ta3\n";
				s1="-"+s1;
				s2=aSeq2.substr(j,1)+s2;
				j--;
				if ( j == 0 )
				{
					s1=aSeq1.substr(i,1)+s1;
					s2=aSeq2.substr(j,1)+s2;
				}
			}
			else if ( i == 0 && j > 0 &&
					aSeq1.substr(i,1)!=aSeq2.substr(j,1) && aSeq1.substr(i,1)!=aSeq2.substr(j-1,1) )
			{
				cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\ta4\n";
				s1=aSeq1.substr(i,1)+s1;
				s2=aSeq2.substr(j,1)+s2;
				j--;
				if ( j == 0 )
				{
					s1="-"+s1;
					s2=aSeq2.substr(j,1)+s2;
				}
			}
		}
		else if ( i == 0 && j > 0 && D )
		{	cout << i << " " << j << "\tb\n";
			s1=aSeq1.substr(i,1)+s1;
			s2=aSeq2.substr(j,1)+s2;
			while ( j > 0 )
			{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\tb1\n";
				s1="-"+s1;
				j--;
				s2=aSeq2.substr(j,1)+s2;
			}
		}
		else if ( i > 0 && j > 0 && !H && !D && !V )
		{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\tc\n";
			s1=aSeq1.substr(i,1)+s1;
			s2=aSeq2.substr(j,1)+s2;
			i--;
			j--;
		}
//		horizon
		else if ( i > 0 && j > 0 && H )
		{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\td\n";
			s1=aSeq1.substr(i,1)+s1;
			s2="-"+s2;
			i--;
		}
//		vert
		else if ( i > 0 && j > 0 && V )
		{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\te\n";
			s1="-"+s1;
			s2=aSeq2.substr(j,1)+s2;
			j--;
		}
		else if ( i > 2 && j == 0 )
		{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\tf\n";
			s1=aSeq1.substr(i,1)+s1;
			s2=aSeq2.substr(j,1)+s2;
			i--;
		}
		else if ( i > 0 && j == 0 )
		{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\tg\n";
			if ( aSeq1.substr(i,1)==aSeq2.substr(j,1) )
			{
				s1=aSeq1.substr(i,1)+s1;
				s2=aSeq2.substr(j,1)+s2;
			}
			else
			{
				s1=aSeq1.substr(i,1)+s1;
				s2="-"+s2;
			}
			i--;
			if ( i == 0 )
			{
				if ( aSeq1.substr(i,1)==aSeq2.substr(j,1) )
				{cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\tg1\n";
					s1=aSeq1.substr(i,1)+s1;
					s2=aSeq2.substr(j,1)+s2;
				}
				else
				{cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\tg2\n";
					s1=aSeq1.substr(i,1)+s1;
					s2="-"+s2;
				}
			}
		}
		else
		{	cout << i << " " << aSeq1.substr(i,1) << " " << j << " " << aSeq2.substr(j,1) << "\telse\n";
			s1=aSeq1.substr(i,1)+s1;
			s2=aSeq2.substr(j,1)+s2;
			i--;
			j--;
			if ( i == 0 && j == 0 )
			{
				s1=aSeq1.substr(i,1)+s1;
				s2=aSeq2.substr(j,1)+s2;
			}
		}
		align1=s1;
		align2=s2;
	}
}

/** A method to print aligned sequences with edition distance matrix
*/
void			EdDist::printAlign()
{
	cout <<		align1+"\n"+align2+"\n";
}

/** A method to print operations to pass from seq2seq with edition distance matrix
*/
void			EdDist::printOps()
{
	for (unsigned i = 0 ; i < align1.length() ; i++)
	{
		if ( align1[i]==align2[i] )
			op1to2+="M";
		else
			if ( align1[i]=='-' )
				op1to2+="I";
			else if ( align2[i]=='-' )
				op1to2+="D";
			else
				op1to2+="R";
	}
	cout <<	op1to2;
}

/** A method to get the min
@return	int		a min integer
*/
int				EdDist::min( int inti, int intj ) const
{
	int		mini;
	if ( inti > intj )
		mini	=	intj;
	else
		mini	=	inti;
	return		mini;
}

/** A method to get the isHmin
@return	bool	a boolean if is min or not between D and V
*/
bool			EdDist::isHmin( int inti, int intj )	const
{
	return		( aVect[inti][intj] <= aVect[inti][intj-1] &&
					aVect[inti][intj] <= aVect[inti+1][intj-1]);
}

/** A method to get the isDmin
@return	bool	a boolean if is min or not between H and V
*/
bool			EdDist::isDmin( int inti, int intj )	const
{
	return		( aVect[inti][intj] <= aVect[inti][intj+1] &&
					aVect[inti][intj] <= aVect[inti+1][intj]);
}

/** A method to get the isVmin
@return	bool	a boolean if is min or not between D and H
*/
bool			EdDist::isVmin( int inti, int intj )	const
{
	return		( aVect[inti][intj] <= aVect[inti-1][intj] &&
					aVect[inti][intj] <= aVect[inti-1][intj+1]);
}


