#include	"GStack.hpp"
#include	<cassert>
#include	<boost/regex.hpp>


//constructor
template <class T>
GStack<T>::GStack()
{
	//null pointer
	topSeq			=	0;
}

//destructor
template <class T>
GStack<T>::~GStack()
{
	SeqPtr	tempPtr;
	//cleanning
	while ( topSeq != 0 ) {
		tempPtr		=	topSeq;
		topSeq		=	topSeq->nextSeq;
		delete		tempPtr;
	}
}

/** A method to add elements
@param	T		a template to push into the stack
*/
template <class T>
void	GStack<T>::push(T Element)
{
	//memory allocation
	SeqPtr	newPtr	=	new	SeqType;
	//memory allocation verification
	assert ( newPtr != 0 );
	//value copy
	newPtr->seqData	=	Element;
	//2nd element is now summit
	newPtr->nextSeq	=	topSeq;
	//summit is new element
	topSeq			=	newPtr;
}

/** A method to remove elements
*/
template <class T>
void	GStack<T>::pop()
{
	SeqPtr	tempPtr	=	topSeq;
	//existance verification
	assert ( topSeq != 0 );
	//2nd element is summit
	topSeq			=	topSeq->nextSeq;
	//free memory
	delete			tempPtr;
}

/** A method to fetch the top element
@return	element	a template representing the first element
*/
template <class T>
T		GStack<T>::peek() const
{
	//existance verification
	assert ( topSeq != 0 );
	//return summit
	return			topSeq->seqData;
}

/** A method to get the depth
@return	int		an integer the depth of the stack
*/
template <class T>
int		GStack<T>::getDepth() const
{
	int seqCounter		=	0;
	//from summit
	SeqPtr	tempPtr	=	topSeq;
	//to all element
	while ( tempPtr != 0 ) {
		seqCounter++;
		//go next
		tempPtr		=	tempPtr->nextSeq;
	}
	return			seqCounter;
}

/** A method to verify an empty stack
@return	bool	a boolean representing an empty stack or not
*/
template <class T>
bool	GStack<T>::isEmpty() const
{
	return		(topSeq	==	0);
}

