#cat DOF.CSV|tail -n+1 |awk -F, '{if ($12>400) {printf("%s,%s,%s,%s,%s\n", $6,$7,$12,$13,$10)}}'
cat DOF.CSV|tail -n+2 |awk -F, '{if ($12>400) {printf("%s,%s,%i\n", $6,$7,$13)}}'

