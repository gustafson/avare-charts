## sed "s/  */ /g" approaches.txt|sed "s/, /,/g"|sed "s/ ,/,/g" > /dev/shm/tmp.txt; mv /dev/shm/tmp.txt approaches.txt

FILE=`../cycledates.sh 28 plates`/FAACIFP18

./cifpscan $FILE

echo complete parsing


sed  s/" "//g approaches.txt |sort -u > /dev/shm/tmp.txt; mv /dev/shm/tmp.txt approaches.txt;
[[ -f procedures.db ]] && rm procedures.db
sqlite3 procedures.db < importcifp.sql && rm approaches.txt

echo File parsed was $FILE


## Test
## sqlite3 procedures.db "select InitialCourse from procedures where Airport=='KBOS' and Runway=='R32';"
