#!/bin/bash

LINE2FASTA="line2fasta.pl"
LINE2FASTAQUAL="line2fasta.pl --qual"

if [[ -z $* ]]; then
	echo "Specify lib dir where seq.tab and qual.tab pairs are found.";
	exit -1
fi

LIB=$*

echo "line2fasta ..."
find $LIB -name \*.seq.tab | while read i; do 
	echo $i;
	$LINE2FASTA <$i >$(echo $i| sed 's/\.seq\.tab$//')
done
echo "line2fastaqual ..."
find $LIB -name \*.qual.tab | while read i; do 
	echo $i;
	$LINE2FASTAQUAL <$i >$(echo $i| sed 's/\.qual.tab$/.qual/')
done

