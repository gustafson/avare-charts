function mygroup(){
    ## echo $1 $2
    ## echo ./gettiles.py $(extract_corners.sh $1) $(cyclenumber.sh) $2
    ./gettiles.py $(extract_corners.sh $1) $(cyclenumber.sh) $2
}

export -f mygroup
CYCLE=$(cyclenumber.sh)
CYCLE=1507


## VFR Tiles
for img in `ls charts/sec/*SEC*.tif charts/wac/*WAC*.tif charts/tac/*TAC*.tif|grep -vi inset`; do
    if [[ $img == *"TAC"* ]]; then
	img=`echo $img |sed s/TAC_/TAC/`
	TYPE=tac;
	BASE=final/`echo $img | cut -d\/ -f3 | sed 's/.\{9\}$//'`TAC.zip
    elif [[ $img == *"WAC"* ]]; then
	TYPE=wac;
	BASE=final/`echo $img | cut -d\/ -f3 | sed 's/.\{9\}$//'`.zip
    elif [[ $img == *"SEC"* ]]; then
	TYPE=sec;
	BASE=final/`echo $img | cut -d\/ -f3 | sed 's/.\{9\}$//'`.zip
    fi

    rm -f $BASE
    zip -9 $BASE `mygroup ${img} ${TYPE}` &
done
wait

## IFR AREA Tiles
for img in `ls charts/ifa/*.tif`; do
    
    BASE=final/ENRA_`echo $img | cut -c 20-22`.zip
    zip -9 $BASE `mygroup ${img}` &
done
wait

## IFR low
## -124.9839444 49.3256861 -62.6234500 23.6965806
## -131.2061028 50.1354444 -62.6652694 23.1391028
rm -fr final/ELUS_NE.zip; zip -9 final/ELUS_NE.zip $(./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifr) &
rm -fr final/ELUS_NC.zip; zip -9 final/ELUS_NC.zip $(./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifr) &
rm -fr final/ELUS_NW.zip; zip -9 final/ELUS_NW.zip $(./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifr) &
rm -fr final/ELUS_SE.zip; zip -9 final/ELUS_SE.zip $(./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifr) &
rm -fr final/ELUS_SC.zip; zip -9 final/ELUS_SC.zip $(./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifr) &
rm -fr final/ELUS_SW.zip; zip -9 final/ELUS_SW.zip $(./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifr) &

rm -fr final/EHUS_NE.zip; zip -9 final/EHUS_NE.zip $(./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifh) &
rm -fr final/EHUS_NC.zip; zip -9 final/EHUS_NC.zip $(./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifh) &
rm -fr final/EHUS_NW.zip; zip -9 final/EHUS_NW.zip $(./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifh) &
rm -fr final/EHUS_SE.zip; zip -9 final/EHUS_SE.zip $(./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifh) &
rm -fr final/EHUS_SC.zip; zip -9 final/EHUS_SC.zip $(./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifh) &
rm -fr final/EHUS_SW.zip; zip -9 final/EHUS_SW.zip $(./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifh) &

wait



for img in merge/heli/*4.vrt; do
    IMG=`echo $img | cut -d\/ -f3 | sed 's/.\{6\}$//'`
    if [[ ${IMG:0:11} == GrandCanyon ]]; then
	IMBASE=${IMG:0:11};
    else
	IMBASE=${IMG}Heli
    fi
    BASE=final/${IMBASE}.zip
    rm -f $BASE
    zip -9 $BASE $(./gettiles.py `./extract_corners.sh merge/heli/${IMG}*4.vrt` ${CYCLE} heli)
done
