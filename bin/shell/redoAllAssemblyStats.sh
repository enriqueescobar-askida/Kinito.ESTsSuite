#!/bin/bash/
myfind='/opt/build/jpdionne/asm35/clones/';

if	[ $# -ne 1 ]	;
	then
		echo	'you entered '$#' arguments, just 1 is needed!' ;
		exit	1	;
	else
				if		[ $1 = 'phrap' ]	;
					then
						my_asm='/opt/build/bioinfo/phrap/distrib/phrap'	;
						mypasm=' -ace -view -minmatch 20 -minscore 30 -retain_duplicates'	;
						my_log=$1'.log'		;
					elif	[ $1 = 'cap3' ]	;
						then
							my_asm='/opt/build/bioinfo/CAP3/CAP3/cap3'	;
							mypasm=' -c 15 -h 50'	;
							my_log=$1'.log'	;
					else
						echo	' assembler unknown!'	;
						exit	1	;
				fi	;

				myseek=$1	;
				my_max=0	;
				my_min=700	;
				my_sum=0	;
				my_avg=0	;
				myline=0	;
				my_ctg=0	;
				my_sgt=0	;

				find $myfind -depth -type d -name $myseek | while read asm_d   ;
					do
						myline=$(($myline+1))			;
						asmdn=`dirname $asm_d`			;
						asmdn=`basename $asmdn`			;
						cd		$asm_d					;
						pwd								;
						if		[ $1 = 'phrap' ]		;
							then
								asmac=$asmdn'.ace'		;
								asmct=$asmdn'.contigs'	;
								asmst=$asmdn'.singlets'	;
							else
								asmac=$asmdn'.cap.ace'	;
								asmct=$asmdn'.cap.contigs'	;
								asmst=$asmdn'.cap.singlets'	;
						fi	;

						if		[ -e $asmac ]			;
							then
								wc_ace=`wc -l $asmac|awk '{print $1;}'`	;
								if		[ $wc_ace -gt 0 ]		;
									then
										if		[ $wc_ace -gt 9 ]		;
											then
												my_ctg=$(($my_ctg+1))	;
												myline=$(($myline+1))	;
												my_len=`grep -m 1 CO	$asmac|awk '{print $3;}'`	;
												if		[ $my_len -gt $my_max ]	;
													then
														my_max=$my_len			;
												fi	;

												if		[ $my_min -gt $my_len ]	;
													then
														my_min=$my_len			;
												fi	;
												
												my_sum=$(($my_sum+$my_len))		;
												my_avg=$(($my_sum/$myline))		;
										fi	;
										
								fi	;
								
							else
								echo	$asmac' inexistant!'	;
						
						fi	;

						if		[ -e $asmct ]			;
							then
								wc_ctg=`wc -l $asmct|awk '{print $1;}'`	;
								if		[ $wc_ctg -gt 0 ]		;
									then
										my_ctg=$my_ctg			;
								fi	;
								
							else
								echo	$asmct' inexistant!'	;

						fi	;

						if		[ -e $asmst ]			;
							then
								wc_sgt=`wc -l $asmst|awk '{print $1;}'`	;
								if		[ $wc_sgt -gt 0 ]		;
									then
										my_sgt=$(($my_sgt+1))	;
								fi	;
								
							else
								echo	$asmst' inexistant!'	;

						fi	;
						
						echo	'contigs '$my_ctg' singlets '$my_sgt' total '$(($my_ctg+$my_sgt));
						echo	'line '$myline' length '$my_len' sum '$my_sum	;
						echo	'max '$my_max' min '$my_min' avg '$my_avg		;
					done						;

fi	;

