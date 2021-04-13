all: procedures.db

## cifpscanc: cifpscan.c
## 	gcc cifpscan.c -o cifpscanc -g
## 
cifpscan: cifpscan.c++ cifpscan.h
	g++ -std=c++11 cifpscan.c++ -O0 -o cifpscan -g

procedures.db: cifpscan
	./createdb.sh
	sqlite3 procedures.db 'select Airport, AppType, Runway, ChangeCycle from procedures'|sort -u|wc

missinglist.txt: procedures.db
	./findmissing.sh |tee missinglist.txt

