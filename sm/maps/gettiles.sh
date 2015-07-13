function mygroup(){
    ## echo $1 $2
    ## echo ./gettiles.py $(extract_corners.sh $1) $(cyclenumber.sh) $2 meters
    ./gettiles.py $(extract_corners.sh $1) $(cyclenumber.sh) $2 meters
}

export -f mygroup
CYCLE=$(cyclenumber.sh)
CYCLE=1507

## THIS WILL DELETE SEC TILES BY CHART
## for img in `ls merge/sec/*Seattle*_c.vrt`; do
##     echo ${img}
##     rm `mygroup ${img} deletesec`
## done
## wait

## THIS WILL DELETE ALL EXPIRED/EXPIRING TILES BY 
## for img in `grep delete expired.txt|cut -f2 -d" "`; do
##     type=`echo ${img}|cut -f2 -d/`
##     echo rm `mygroup ${img} delete${type}`
## done
## wait

## THIS WILL DELETE IFR TILES BY CHART
## for img in `ls merge/ifr/1*_2.vrt`; do #  merge/ifr/1ENR_AKL01_2.vrt
##     ## this is the corner one joining AK 
##     echo ${img}
##     rm `mygroup ${img} deleteifr`
## done
## wait

## THIS WILL DELETE IFH TILES BY CHART
## for img in `ls merge/ifh/*_2.vrt`; do
##     echo ${img}
##     rm `mygroup ${img} deleteifh`
## done
## wait

echo starting vfr
for img in `ls merge/sec/*_c.vrt`; do
    BASE=final/`echo $img | cut -f3 -d/ | cut -c 3-|cut -f1 -d_`.zip
    rm -f $BASE
    echo $BASE
    zip -9 --quiet $BASE `mygroup ${img} sec` &
done
wait
for img in `ls merge/wac/*_c.vrt`; do
    BASE=final/`echo $img | cut -f3 -d/ | cut -c 3-|cut -f1 -d_`.zip
    rm -fr $BASE
    echo $BASE
    zip -9 --quiet $BASE `mygroup ${img} wac` &
done
wait
for img in `ls merge/tac/*_c.vrt`; do
    BASE=final/`echo $img | cut -f3 -d/ | cut -c 4-|cut -f1 -d_`.zip
    rm -f $BASE
    echo $BASE
    zip -9 --quiet $BASE `mygroup ${img} tac` &
done
wait
echo done vfr

echo starting ifr
## IFR AREA Tiles
for img in merge/ifa/*vrt; do
    base=ENRA_`echo ${img} | cut -f3 -d/|cut -f3 -d_|cut -f1 -d.`
    [[ -f final/${base}.zip ]] && rm final/${base}.zip
    zip -9 --quiet final/${base}.zip `mygroup ${img} ifa` &
done
wait

rm -f final/ELUS_AK.zip; zip -9 --quiet final/ELUS_AK.zip $(./gettiles.py -180.00 75.00 -125.00 50.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_NE.zip; zip -9 --quiet final/ELUS_NE.zip $(./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_NC.zip; zip -9 --quiet final/ELUS_NC.zip $(./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_NW.zip; zip -9 --quiet final/ELUS_NW.zip $(./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_SE.zip; zip -9 --quiet final/ELUS_SE.zip $(./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifr latlon) &
rm -f final/ELUS_SC.zip; zip -9 --quiet final/ELUS_SC.zip $(./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifr latlon) &
rm -f final/ELUS_SW.zip; zip -9 --quiet final/ELUS_SW.zip $(./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifr latlon) &

rm -f final/EHUS_AK.zip; zip -9 --quiet final/EHUS_AK.zip $(./gettiles.py -180.00 75.00 -125.00 50.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_NE.zip; zip -9 --quiet final/EHUS_NE.zip $(./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_NC.zip; zip -9 --quiet final/EHUS_NC.zip $(./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_NW.zip; zip -9 --quiet final/EHUS_NW.zip $(./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_SE.zip; zip -9 --quiet final/EHUS_SE.zip $(./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifh latlon) &
rm -f final/EHUS_SC.zip; zip -9 --quiet final/EHUS_SC.zip $(./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifh latlon) &
rm -f final/EHUS_SW.zip; zip -9 --quiet final/EHUS_SW.zip $(./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifh latlon) &
wait
echo done ifr

## SHADED RELIEF ## echo starting relief
## SHADED RELIEF ## cp ../usgs/sr/REL_{AK,HI,PR}.zip final/.
## SHADED RELIEF ## rm -f final/REL_NE.zip; zip -9 --quiet final/REL_NE.zip $(./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} rel latlon) &
## SHADED RELIEF ## rm -f final/REL_NC.zip; zip -9 --quiet final/REL_NC.zip $(./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} rel latlon) &
## SHADED RELIEF ## rm -f final/REL_NW.zip; zip -9 --quiet final/REL_NW.zip $(./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} rel latlon) &
## SHADED RELIEF ## rm -f final/REL_SE.zip; zip -9 --quiet final/REL_SE.zip $(./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} rel latlon) &
## SHADED RELIEF ## rm -f final/REL_SC.zip; zip -9 --quiet final/REL_SC.zip $(./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} rel latlon) &
## SHADED RELIEF ## rm -f final/REL_SW.zip; zip -9 --quiet final/REL_SW.zip $(./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} rel latlon) &
## SHADED RELIEF ## wait
## SHADED RELIEF ## echo done relief

## TERRAIN ## echo starting terrain
## TERRAIN ## cp ../elevation/ELEV_{AK,HI,PR}.zip final/.
## TERRAIN ## rm -f final/ELEV_NE.zip; zip -9 final/ELEV_NE.zip $(./gettiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} elev latlon) &  ## --quiet 
## TERRAIN ## rm -f final/ELEV_NC.zip; zip -9 final/ELEV_NC.zip $(./gettiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} elev latlon) &  ## --quiet 
## TERRAIN ## rm -f final/ELEV_NW.zip; zip -9 final/ELEV_NW.zip $(./gettiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} elev latlon) &  ## --quiet 
## TERRAIN ## rm -f final/ELEV_SE.zip; zip -9 final/ELEV_SE.zip $(./gettiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} elev latlon) &  ## --quiet 
## TERRAIN ## rm -f final/ELEV_SC.zip; zip -9 final/ELEV_SC.zip $(./gettiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} elev latlon) &  ## --quiet 
## TERRAIN ## rm -f final/ELEV_SW.zip; zip -9 final/ELEV_SW.zip $(./gettiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} elev latlon) &  ## --quiet 
## TERRAIN ## wait
## TERRAIN ## echo done terrain

## HELI ## echo starting heli
## HELI ## ## Heli
## HELI ## for img in `ls merge/heli/*2.vrt|grep -v North|grep -v South|grep -v East|grep -v West|grep -v NewYork_2` merge/heli/*3.vrt; do
## HELI ##     IMG=`echo $img | cut -d\/ -f3 | sed 's/.\{6\}$//'`
## HELI ##     if [[ ${IMG:0:11} == GrandCanyon ]]; then
## HELI ## 	IMBASE=${IMG:0:11};
## HELI ##     else
## HELI ## 	IMBASE=${IMG}Heli
## HELI ##     fi
## HELI ##     BASE=final/${IMBASE}.zip
## HELI ##     rm -f $BASE
## HELI ##     FILE=`find merge/heli/${IMG}*|grep 3`
## HELI ##     if [[ -f ${FILE} ]]; then
## HELI ## 	#echo `ls merge/heli/${IMG}*3.vrt`
## HELI ## 	zip -9 --quiet $BASE $(./gettiles.py `./extract_corners.sh merge/heli/${IMG}*3.vrt` ${CYCLE} heli meters) &
## HELI ##     else
## HELI ## 	#echo `ls merge/heli/${IMG}*2.vrt`
## HELI ## 	zip -9 --quiet $BASE $(./gettiles.py `./extract_corners.sh merge/heli/${IMG}*2.vrt` ${CYCLE} heli meters) &
## HELI ##     fi
## HELI ## done
## HELI ## wait
## HELI ## echo done heli


make zipittest
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} sec latlon|grep "tiles/..../0/7"`   ## --quiet 
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} tac latlon|grep "tiles/..../1/8"`	  ## --quiet 
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} wac latlon|grep "tiles/..../2/6"`	  ## --quiet 
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} ifr latlon|grep "tiles/..../3/7"`	  ## --quiet 
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} ifh latlon|grep "tiles/..../4/6"`	  ## --quiet 
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} ifa latlon|grep "tiles/..../5/8"`	  ## --quiet 
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} elev latlon|grep "tiles/..../6/6"`  ## --quiet 
zip -9 final/databases.zip `./gettiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} rel latlon|grep "tiles/..../7/6"`	  ## --quiet 
echo done databases

## THIS is canadian topo
## for img in `ls ../can-topo/[0-9]*vrt`; do
##     base=`echo $img|cut -f3 -d/|cut -f1 -d.`
##     [[ -f final/CAN_${base}.zip ]] && rm final/CAN_${base}.zip
##     zip -9 --quiet final/CAN_${base}.zip `mygroup ${img} topo`
## done
## wait

