#ifndef		STRSET_HPP
#define		STRSET_HPP
#include	<string>
#include	<set>

 /** @class StrSet StrSet.hpp Package/StrSet.hpp

    Class allowing to create a ordered string set
 
    @author Enrique Escobar
    @date	27/02/2007
*/

struct	lessThenStr
{

	bool	operator() ( const std::string& s1, const std::string& s2 ) const
	{
		return			( s1.size() == s2.size() ? s1 < s2 : s1.size() < s2.size() ) ;
	}
};

typedef	std::set<std::string, lessThenStr> StrSet;


#endif

