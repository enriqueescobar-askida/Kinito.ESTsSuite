#ifndef		GSTACK_HPP
#define		GSTACK_HPP
#include	<string>


/** @class GStack GStack.hpp Package/GStack.hpp

    Class allowing to manipulate sequence strings
 
    @author Enrique Escobar
    @date	20/02/2007
*/
template <class T>
class	GStack
{
public:
	//constructor
	GStack();
	
	//destructor
	~GStack();
		
	/** A method to add elements
    @param	T		a template to push into the stack
	*/
	void	push(T Element);
	
	/** A method to remove elements
	*/
	void	pop();
	
	/** A method to fetch the top element
    @return	element	a template representing the first element
	*/
	T		peek()		const;
	
	/** A method to get the depth
    @return	int		an integer the depth of the stack
	*/
	int		getDepth()	const;
	
	/** A method to verify an empty stack
	@return	bool	a boolean representing an empty stack or not
	*/
	bool	isEmpty()	const;


private:	
	struct	SeqType;
	
	typedef	SeqType *SeqPtr;

	//seq list
	struct	SeqType
	{
		T		seqData;
		SeqPtr	nextSeq;
	};
	
	SeqType	*topSeq;
};

#endif
