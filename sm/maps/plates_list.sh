#!/bin/bash

CYCLE=$(./cyclenumber.sh)

find plates/plates.archive/${CYCLE}/plates_* -name '*pdf' |
    sort | awk -F _ '{print $2}' | sed s/.pdf/.png/ > list${CYCLE}.txt
cp list${CYCLE}.txt list.txt
gzip -9 list${CYCLE}.txt
