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
				
				find $myfind -type d -name $myseek | while read asm_d   ;
					do
						asmdn=`dirname $asm_d`	;
						asmdn=`basename $asmdn`	;
						cd		$asm_d	;
						pwd				;
						ls		$asm_d	;
						$my_asm $asmdn $mypasm > $my_log	;
						if	[ $? -gt 0	]	;
							then
								touch	error	;
						fi	;
						
						ls		$asm_d	;
						if	[ $1 = 'cap3' ]	;
							then
								as_date=`date +%d%m%y:%k%M%S`	;
								echo			>> $my_log		;
								echo	'WA{'	>> $my_log		;
								echo	'cap3_params cap3 '$as_date	>> $my_log	;
								echo	$my_asm' '$asmdn' '$mypasm	>> $my_log	;
								echo	'cap3 version 3'			>> $my_log	;
								echo	'}'		>> $my_log		;
								echo			>> $my_log		;
								echo			>> $my_log		;
						fi	;
						
					done	;
					
fi	;

