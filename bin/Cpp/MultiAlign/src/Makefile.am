prefix = @prefix@

DEFS=@DEFS@ \
     -DLOCALEDIR=\"${LOCALEDIR}\" \
     -DDATADIR=\"$(DATADIR)\" \
     -DPROJECTNAME=\"/${PACKAGE}\"
INCLUDES = -I../.. \
	   -I$(top_srcdir)/intl

bin_PROGRAMS=super

super_SOURCES=EdDist.cpp  EdDist.hpp  GenetiCode.cpp  GenetiCode.hpp  GReader.cpp  GStack.cpp  GStack.hpp  Sequence.cpp  Sequence.hpp  StrSet.hpp

super_LDADD =   -lboost_regex \
		-lboost_program_options \
		-lboost_filesystem 

super_LDFLAGS = -Wall

AM_CXXFLAGS = -Wall
