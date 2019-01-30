/***************************************************************************
*   Copyright (C) 2007 by Enrique Escobar   *
*   Enrique.Escobar@genome.ulaval.ca   *
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU Library General Public License as       *
*   published by the Free Software Foundation; either version 2 of the    *
*   License, or (at your option) any later version.                       *
*                                                                         *
*   This program is distributed in the hope that it will be useful,       *
*   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
*   GNU General Public License for more details.                          *
*                                                                         *
*   You should have received a copy of the GNU Library General Public     *
*   License along with this program; if not, write to the                 *
*   Free Software Foundation, Inc.,                                       *
*   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
***************************************************************************/
#ifdef		HAVE_CONFIG_H
#include	<config.h>
#endif

#include	<iostream>	//std io
#include	<cstdlib>

#include	<fstream>	//file io
#include	<list>
#include	<map>
#include	<string>

//#include	"GStack.hpp"
//#include	"GStack.cpp"
//#include	"Sequence.hpp"
#include	"StrSet.hpp"

using		namespace std;

//GStack<Sequence>	mySeqStack;

StrSet myStrSet;

int			main( int argc, char *argv[] )
{
	cout				<< "Beginning!\n";
	
	if ( argc != 3 )
	{
		cerr			<< "Wrong number of parameters!\n" << endl;
		
		return			EXIT_FAILURE;
	}
	
	string	in_FileName	=	argv[1];
	string	outFileName	=	argv[2];
	
	cerr			<< "@param1=" << argv[1] << "\t" << "@param2=" << argv[2] << "\n" << endl;
	
	if ( in_FileName == outFileName )
	{
		cerr		<< "Idem parameters!\n" << endl;
		
		return		EXIT_FAILURE;
	}
	
	
	ifstream			input_Stream( argv[1], ios::in  );
	if ( input_Stream.fail() )
	{
		cerr			<< "Cannot open file" << in_FileName << endl;
		
		return			EXIT_FAILURE;
	}
	
	string	str			=	"";
//	Sequence			mySeq;
	
	while ( input_Stream.good() )
	{
		getline( input_Stream, str );
		if( ! input_Stream.eof() )
		{
//			mySeq		=	Sequence( str );
//			mySeqStack.push( mySeq );
			myStrSet.insert( str );
			cout		<< ">>" << myStrSet.size() << "\t" << str << "\n";
		}
		else
		{
			break;
		}
	}
	
	ofstream			outputStream( argv[2], ios::out );
	if ( outputStream.fail() )
	{
		cerr			<< "Cannot open file" << outFileName << endl;
		
		return			EXIT_FAILURE;
	}
	
	input_Stream.close();
	outputStream.close();
	
	StrSet::iterator	StrSetIt;
	
	for ( StrSetIt = myStrSet.begin(); StrSetIt != myStrSet.end(); StrSetIt++ )
	{
		cout << *StrSetIt+"\n";
	}
	cout				<< "\nEnding!\n";


	return				EXIT_SUCCESS;
}


