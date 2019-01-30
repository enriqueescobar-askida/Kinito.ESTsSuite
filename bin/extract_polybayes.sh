grep SNP_ID: polybayes_out.txt |  awk '{printf("%s\t%s\t%f\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",$4,$6,$16,$8,$10,$12,$14,$34,$32,$40)}'|sort -k 1,1
