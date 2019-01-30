# grep contig in sifaka file
grep Contig $1 | sort -k1,3 |
while read sif						;
# fetching important columns
do  sif=`echo $sif| awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12}'`;
	echo $sif;done;
# # +/- strand
# 	sig=`echo $sif| awk '{print $7}'`;
# # qry start
# 	sqs=`echo $sif| awk '{print $8}'`;
# # qry end
# 	sqe=`echo $sif| awk '{print $9}'`;
# # hit start
# 	shs=`echo $sif| awk '{print $10}'`;
# # hit end
# 	she=`echo $sif| awk '{print $11}'`;
# # snp position calculation following the strand
# 	ses=$((31-sqs))					;
# 	if [ $sig = "+" ] 				;
# 	then
# 		ses=$((shs+ses))			;
# 	else
# 		ses=$((she-ses))			;
# 	fi 								;
# 	hit=`echo $sif| awk '{print $3}'`;
# 	snp=`echo $sif| awk '{print $1}'`;
# # find path of contig in directory list file
# 	clu=`echo $sif| awk '{print $3}' | sed -r 's/\.Contig[0-9]+$//'`;
# 	ctg=`echo $hit| sed -r 's/^.+\.//'`;
# 	pazh=`grep $clu dir_list.tab| awk '{print $2}'`;
# # sifaka dir8 file
# 	sil=$pazh'/'$clu'.sifaka.snp_dir8';
# # seq.tab file
# 	seq=$pazh'/'$clu'.seq.tab'		;
# # qual.tab file
# 	cal=$pazh'/'$clu'.qual.tab'		;
# # snp 2 contig file
# 	stg=$pazh'/snp2contig.txt'		;
# # est file
# 	est=$pazh'/blast_contigs_ests'	;
# # snp nucleotide
# 	snpn=`perl sifaka_polybayes_snp2bp.pl   -c $clu -p $ses -q $seq 2>/dev/null`;
# # snp quality
# 	snpq=`perl sifaka_polybayes_snp2qual.pl -c $clu -p $ses -q $cal 2>/dev/null`;
# # echo $sif' '$clu' '$snp' '$ses'@'$snpn'@'$snpq;
# 	if [ ! -e $snpn ]				;
# 	then
# 		echo 'rm '$pazh'/{*.sifaka.snp_dir8,snp2contig.txt}'	;
# 		if [ ! -e $sil ]			;
# 		then
# 			echo $sif' '$ses' '$snpn' '$snpq > $sil;
# 		else
# 			echo $sif' '$ses' '$snpn' '$snpq >> $sil;
# 		fi							;
# 	fi ;
# 	perl sifaka_polybayes_snp2contig.pl -d $sil -o $stg -e $est -s $seq -q $cal;
# done								;

