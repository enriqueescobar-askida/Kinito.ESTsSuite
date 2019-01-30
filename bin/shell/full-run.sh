#!/bin/bash

#LIBS="GQ028"
LIBS="GQ029 GQ030 GQ031 GQ032"

PHRAP_BIN=/opt/build/bioinfo/phrap/distrib/phrap
PHRAP_OPT="-ace -view -minmatch 20 -minscore 30 -retain_duplicates"
PREPARE_PHRAP=/opt/build/jpdionne/asm35/sequtils/3-5_clone_assembly/prepare-phrap.rb
BASE_DIR=/opt/build/jpdionne/asm35/clones
BASE_CALLER_NAME=phred-040406
ASSEMBLER_NAME=phrap

ulimit -c 10000000

# ./sequtils/3-5_clone_assembly/prepare-phrap.rb --lib-name GQ028 --base-caller-name phred-040406 --assembler-name phrap --base-dir /opt/build/jpdionne/asm35/clones --seq-tab GQ028_HQ.seq.tab --qual-tab GQ028_HQ.qual.tab > out.sh > GQ028_HQ-prepare-for-phrap.sh
for lib in $LIBS; do
	$PREPARE_PHRAP --lib-name $lib \
	--base-caller-name $BASE_CALLER_NAME \
	--assembler-name $ASSEMBLER_NAME \
	--base-dir $BASE_DIR \
	--seq-tab ${lib}_HQ.seq.tab \
	--qual-tab ${lib}_HQ.qual.tab > ${lib}_HQ-prepare-for-phrap.sh
	bash ${lib}_HQ-prepare-for-phrap.sh
done

./batch-line2fasta.sh $BASE_DIR

cat ${BASE_DIR}/${lib}/clone_list.tab | while read clone dir reads ; do 
	if [[ -d $dir ]]; then
		cd $dir
		echo "Running Phrap into $dir..."
		$PHRAP_BIN $PHRAP_OPT $clone > ${dir}/phrap.log 2>&1
	else
		echo "$dir doesn't exists"
	fi
done

echo "End of full-run.sh."

