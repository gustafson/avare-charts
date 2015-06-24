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



## find [345] -name "*png"| xargs rename .png .png.orig
## find [345] -name "*png8"| xargs rename .png8 .png
## find [345] -name "*png"|xargs -n1 -P16 optipng
