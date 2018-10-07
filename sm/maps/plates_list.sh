#!/bin/bash

CYCLE=$(./cyclenumber.sh)

find plates.archive/${CYCLE}/plates_* -name '*pdf'|sort|awk -F _ '{print $2}' | sed s/.pdf/.png/ > list${CYCLE}.txt
#find plates_[A-Z][A-Z] -type f |cut -c 8-|sed s/.pdf/.png/ 
cp list${CYCLE}.txt list.txt
gzip -9 list${CYCLE}.txt
