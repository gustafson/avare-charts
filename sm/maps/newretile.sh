## for a in 50 60 70 75 80 85 90; do 
##     find . -name "*\.${a}.jpg" -print0 |du -shc --files0-from=-|grep -v jpg
## done
## 
## find -name "*.png" -size -855c
## 
## 
## #  rename .jpg .70.jpg `find . -name "*jpg"|grep -v "\.[56789]0\.jpg"`


### NOTE don't remove the empy files because they will need to be regenerated
## function rmemptypng(){
##     echo $0
##     [[ `convert $0 -format '%@' info: 2> /dev/null|cut -c 1-3` == "0x0" ]] && rm $0
## }
## export -f rmemptypng
## find . -name "*png" | xargs -n1 -P64 bash -c rmemptypng

CYCLE=$(cyclenumber.sh)
CYCLE=1507


function topng8(){
    echo $0
    convert $0 png8:${0}.png8.png
    mv ${0}.png8.png ${0}
    optipng -quiet ${0}
}
export -f topng8

#find tiles/$(./cyclenumber.sh)/5 -name "*png"|xargs -n 1 -P 16 bash -c topng8
#find tiles/$(./cyclenumber.sh)/3 -name "*png"|xargs -n 1 -P 16 optipng -preserve -quiet

## ./gettiles.py -180.00 75.00 -125.00 50.00 1507 ifr |xargs identify 2>&1 >> temp.txt
## ./gettiles.py  -85.00 50.15  -40.00 38.00 1507 ifr |xargs identify 2>&1 >> temp.txt
## ./gettiles.py -110.00 50.15  -85.00 38.00 1507 ifr |xargs identify 2>&1 >> temp.txt 
## ./gettiles.py -131.21 50.15 -110.00 38.00 1507 ifr |xargs identify 2>&1 >> temp.txt
## ./gettiles.py  -85.00 38.00  -40.00 23.13 1507 ifr |xargs identify 2>&1 >> temp.txt
## ./gettiles.py -110.00 38.00  -85.00 23.13 1507 ifr |xargs identify 2>&1 >> temp.txt
## ./gettiles.py -131.21 38.00 -110.00 23.13 1507 ifr |xargs identify 2>&1 >> temp.txt


## The following compresses only the files that are remade

## ./gettiles.py -180.00 75.00 -125.00 50.00 ${CYCLE} ifr |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifr |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifr |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifr |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifr |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifr |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifr |xargs -n 1 -P 16 bash -c topng8

## ./gettiles.py -180.00 75.00 -125.00 50.00 ${CYCLE} ifh |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifh |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifh |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifh |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifh |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifh |xargs -n 1 -P 16 bash -c topng8
## ./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifh |xargs -n 1 -P 16 bash -c topng8

