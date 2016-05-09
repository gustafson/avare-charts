#!/bin/bash
# Copyright (c) Peter A. Gustafson (peter.gustafson@wmich.edu)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

function mygroup(){
    # echo $1 $2
    corners=`extract_corners.sh $1`
    ./ziptiles.py $corners $2 meters
}

export -f mygroup
CYCLE=$(cyclenumber.sh)

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
## for img in merge/ifr/{0ENR_AKL01,1ENR_L01}.vrt; do # `ls merge/ifr/1*_2.vrt`; do #
##     echo ${img}
##     rm `mygroup ${img} deleteifr`
## done
## wait

## THIS WILL DELETE IFH TILES BY CHART
## for img in `ls merge/ifh/00ENR_AKH01_2.vrt merge/ifh/03ENR_H01_2.vrt`; do
##     echo ${img}
##     rm `mygroup ${img} deleteifh`
## done
## wait
## 
## echo starting vfr
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

rm -f final/ELUS_AK.zip; zip -9 --quiet final/ELUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ifr latlon) &
rm -f final/ELUS_NE.zip; zip -9 --quiet final/ELUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ifr latlon) &
rm -f final/ELUS_NC.zip; zip -9 --quiet final/ELUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ifr latlon) &
rm -f final/ELUS_NW.zip; zip -9 --quiet final/ELUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ifr latlon) &
rm -f final/ELUS_SE.zip; zip -9 --quiet final/ELUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ifr latlon) &
rm -f final/ELUS_SC.zip; zip -9 --quiet final/ELUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ifr latlon) &
rm -f final/ELUS_SW.zip; zip -9 --quiet final/ELUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ifr latlon) &

rm -f final/EHUS_AK.zip; zip -9 --quiet final/EHUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ifh latlon) &
rm -f final/EHUS_NE.zip; zip -9 --quiet final/EHUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ifh latlon) &
rm -f final/EHUS_NC.zip; zip -9 --quiet final/EHUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ifh latlon) &
rm -f final/EHUS_NW.zip; zip -9 --quiet final/EHUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ifh latlon) &
rm -f final/EHUS_SE.zip; zip -9 --quiet final/EHUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ifh latlon) &
rm -f final/EHUS_SC.zip; zip -9 --quiet final/EHUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ifh latlon) &
rm -f final/EHUS_SW.zip; zip -9 --quiet final/EHUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ifh latlon) &
wait
echo done ifr

## echo starting relief
rm -f static/REL_AK.zip; zip -9 --quiet static/REL_AK.zip $(./ziptiles.py -179.90  75.0 -128.45 50.50 rel latlon) &
rm -f static/REL_HI.zip; zip -9 --quiet static/REL_HI.zip $(./ziptiles.py -165.00  25.0 -150.00 15.00 rel latlon) &
rm -f static/REL_PR.zip; zip -9 --quiet static/REL_PR.zip $(./ziptiles.py  -68.00  19.5  -64.00 17.00 rel latlon) &
rm -f static/REL_NE.zip; zip -9 --quiet static/REL_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 rel latlon) &
rm -f static/REL_NC.zip; zip -9 --quiet static/REL_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 rel latlon) &
rm -f static/REL_NW.zip; zip -9 --quiet static/REL_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 rel latlon) &
rm -f static/REL_SE.zip; zip -9 --quiet static/REL_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 rel latlon) &
rm -f static/REL_SC.zip; zip -9 --quiet static/REL_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 rel latlon) &
rm -f static/REL_SW.zip; zip -9 --quiet static/REL_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 rel latlon) &
wait
## echo done relief
## 
## echo starting terrain
## AK Upper Left  (-3327000.000, 2438000.000) (142d44' 7.99"E, 56d30' 7.45"N)
## AK Lower Left  (-3327000.000,  346000.000) (163d25'20.02"E, 43d 3'12.40"N)
## AK Upper Right ( 1654000.000, 2438000.000) (113d28'58.51"W, 67d12'45.81"N)
## AK Lower Right ( 1654000.000,  346000.000) (130d24'21.38"W, 50d26'41.22"N)
## AK Center      ( -836500.000, 1392000.000) (169d57'59.56"W, 61d35'50.85"N)

rm -f static/ELEV_AK.zip; zip -9 static/ELEV_AK.zip $(./ziptiles.py -179.90  75.0 -128.45 50.50 elev latlon) &  ## --quiet 
rm -f static/ELEV_HI.zip; zip -9 static/ELEV_HI.zip $(./ziptiles.py -165.00  25.0 -150.00 15.00 elev latlon) &  ## --quiet 
rm -f static/ELEV_PR.zip; zip -9 static/ELEV_PR.zip $(./ziptiles.py  -68.00  19.5  -64.00 17.00 elev latlon) &  ## --quiet 
rm -f static/ELEV_NE.zip; zip -9 static/ELEV_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 elev latlon) &  ## --quiet 
rm -f static/ELEV_NC.zip; zip -9 static/ELEV_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 elev latlon) &  ## --quiet 
rm -f static/ELEV_NW.zip; zip -9 static/ELEV_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 elev latlon) &  ## --quiet 
rm -f static/ELEV_SE.zip; zip -9 static/ELEV_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 elev latlon) &  ## --quiet 
rm -f static/ELEV_SC.zip; zip -9 static/ELEV_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 elev latlon) &  ## --quiet 
rm -f static/ELEV_SW.zip; zip -9 static/ELEV_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 elev latlon) &  ## --quiet 
wait
## echo done terrain
## 
## echo starting heli
## ## Heli
## for img in `ls merge/heli/*2.vrt|grep -v North|grep -v South|grep -v East|grep -v West|grep -v NewYork_2` merge/heli/*3.vrt; do
##     IMG=`echo $img | cut -d\/ -f3 | sed 's/.\{6\}$//'`
##     if [[ ${IMG:0:11} == GrandCanyon ]]; then
## 	IMBASE=${IMG:0:11};
##     else
## 	IMBASE=${IMG}Heli
##     fi
##     BASE=final/${IMBASE}.zip
##     rm -f $BASE
##     FILE=`find merge/heli/${IMG}*|grep 3`
##     if [[ -f ${FILE} ]]; then
## 	#echo `ls merge/heli/${IMG}*3.vrt`
## 	zip -9 --quiet $BASE $(./ziptiles.py `./extract_corners.sh merge/heli/${IMG}*3.vrt` heli meters) &
##     else
## 	#echo `ls merge/heli/${IMG}*2.vrt`
## 	zip -9 --quiet $BASE $(./ziptiles.py `./extract_corners.sh merge/heli/${IMG}*2.vrt` heli meters) &
##     fi
## done
## wait
## echo done heli
## 
## echo start Candian topo
## for img in `ls ../can-topo/[0-9]*vrt`; do
##     base=`echo $img|cut -f3 -d/|cut -f1 -d.`
##     [[ -f final/CAN_${base}.zip ]] && rm final/CAN_${base}.zip
##     echo final/CAN_${base}.zip
##     zip -9 --quiet final/CAN_${base}.zip `mygroup ${img} topo`
## done
## wait
## echo done topo
##
## echo start TPC
## for img in `ls ../tpc/*2.vrt`; do
##     base=`echo $img|cut -f3 -d/|cut -f1 -d.|sed s/_2//`
##     [[ -f final/TPC_${base}.zip ]] && rm final/TPC_${base}.zip
##     echo final/TPC_${base}.zip
##     ## mygroup ${img} tpc
##     zip -9 --quiet final/TPC_${base}.zip `mygroup ${img} tpc`
## done
## wait
## echo done topo
## 
## ALTERNATIVE TO ADD OVERVIEW TILES ## 
## make zipit
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 sec latlon|grep "tiles/..../0/7"`   ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 tac latlon|grep "tiles/..../1/8"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 wac latlon|grep "tiles/..../2/6"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ifr latlon|grep "tiles/..../3/7"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ifh latlon|grep "tiles/..../4/6"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ifa latlon|grep "tiles/..../5/8"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 elev latlon|grep "tiles/..../6/6"`  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 rel latlon|grep "tiles/..../7/6"`	  ## --quiet 
## echo done databases

## OBSOLUTE WITH CHART POLYGONS ## ## Now create manifest
## OBSOLUTE WITH CHART POLYGONS ## pushd final
## OBSOLUTE WITH CHART POLYGONS ## rm -f ../tiledatabase.txt
## OBSOLUTE WITH CHART POLYGONS ## for a in *zip; do
## OBSOLUTE WITH CHART POLYGONS ##     b=`basename $a .zip`;
## OBSOLUTE WITH CHART POLYGONS ##     #zip -d $a $b
## OBSOLUTE WITH CHART POLYGONS ##     #../zip.py `basename ${a} .zip` ${CYCLE};
## OBSOLUTE WITH CHART POLYGONS ##     unzip -l ${a} |grep tiles/${CYCLE}/./8 | cut -f 3- -d/ | cut -f1 -d. |
## OBSOLUTE WITH CHART POLYGONS ## 	while read img; do
## OBSOLUTE WITH CHART POLYGONS ## 	    echo "${b},${img}" >> ../tiledatabase.txt
## OBSOLUTE WITH CHART POLYGONS ## 	done
## OBSOLUTE WITH CHART POLYGONS ## done
## OBSOLUTE WITH CHART POLYGONS ## popd
## OBSOLUTE WITH CHART POLYGONS ## 
## OBSOLUTE WITH CHART POLYGONS ## ## Now create tile lookup database
## OBSOLUTE WITH CHART POLYGONS ## rm -f tiles.db
## OBSOLUTE WITH CHART POLYGONS ## cat << EOF  | sqlite3 tiles.db
## OBSOLUTE WITH CHART POLYGONS ## CREATE TABLE tiles(zip Text,tile Text);
## OBSOLUTE WITH CHART POLYGONS ## .separator ','
## OBSOLUTE WITH CHART POLYGONS ## .import tiledatabase.txt tiles
## OBSOLUTE WITH CHART POLYGONS ## EOF
