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
## TEMP ## ## echo starting vfr
## TEMP ## for img in `ls merge/sec/*_c.vrt`; do
## TEMP ##     BASE=final/`echo $img | cut -f3 -d/ | cut -c 3-|cut -f1 -d_`.zip
## TEMP ##     rm -f $BASE
## TEMP ##     echo $BASE
## TEMP ##     zip -9 --quiet $BASE `mygroup ${img} sec` &
## TEMP ## done
## TEMP ## wait
## TEMP ## for img in `ls merge/wac/*_c.vrt`; do
## TEMP ##     BASE=final/`echo $img | cut -f3 -d/ | cut -c 3-|cut -f1 -d_`.zip
## TEMP ##     rm -fr $BASE
## TEMP ##     echo $BASE
## TEMP ##     zip -9 --quiet $BASE `mygroup ${img} wac` &
## TEMP ## done
## TEMP ## wait
## TEMP ## for img in `ls merge/tac/*_c.vrt`; do
## TEMP ##     BASE=final/`echo $img | cut -f3 -d/ | cut -c 4-|cut -f1 -d_`.zip
## TEMP ##     rm -f $BASE
## TEMP ##     echo $BASE
## TEMP ##     zip -9 --quiet $BASE `mygroup ${img} tac` &
## TEMP ## done
## TEMP ## wait
## TEMP ## echo done vfr
## TEMP ## 
## TEMP ## echo starting ifr
## TEMP ## ## IFR AREA Tiles
## TEMP ## for img in merge/ifa/*vrt; do
## TEMP ##     base=ENRA_`echo ${img} | cut -f3 -d/|cut -f3 -d_|cut -f1 -d.`
## TEMP ##     [[ -f final/${base}.zip ]] && rm final/${base}.zip
## TEMP ##     zip -9 --quiet final/${base}.zip `mygroup ${img} ifa` &
## TEMP ## done
## TEMP ## wait
## TEMP ## 
## TEMP ## rm -f final/ELUS_AK.zip; zip -9 --quiet final/ELUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ifr latlon) &
## TEMP ## rm -f final/ELUS_NE.zip; zip -9 --quiet final/ELUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ifr latlon) &
## TEMP ## rm -f final/ELUS_NC.zip; zip -9 --quiet final/ELUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ifr latlon) &
## TEMP ## rm -f final/ELUS_NW.zip; zip -9 --quiet final/ELUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ifr latlon) &
## TEMP ## rm -f final/ELUS_SE.zip; zip -9 --quiet final/ELUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ifr latlon) &
## TEMP ## rm -f final/ELUS_SC.zip; zip -9 --quiet final/ELUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ifr latlon) &
## TEMP ## rm -f final/ELUS_SW.zip; zip -9 --quiet final/ELUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ifr latlon) &
## TEMP ## 
## TEMP ## rm -f final/EHUS_AK.zip; zip -9 --quiet final/EHUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ifh latlon) &
## TEMP ## rm -f final/EHUS_NE.zip; zip -9 --quiet final/EHUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ifh latlon) &
## TEMP ## rm -f final/EHUS_NC.zip; zip -9 --quiet final/EHUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ifh latlon) &
## TEMP ## rm -f final/EHUS_NW.zip; zip -9 --quiet final/EHUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ifh latlon) &
## TEMP ## rm -f final/EHUS_SE.zip; zip -9 --quiet final/EHUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ifh latlon) &
## TEMP ## rm -f final/EHUS_SC.zip; zip -9 --quiet final/EHUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ifh latlon) &
## TEMP ## rm -f final/EHUS_SW.zip; zip -9 --quiet final/EHUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ifh latlon) &
## TEMP ## wait
## TEMP ## echo done ifr
## TEMP ## 
## TEMP ## ## echo starting relief
## TEMP ## rm -f static/REL_AK.zip; zip -9 --quiet static/REL_AK.zip $(./ziptiles.py -179.90  75.0 -128.45 50.50 rel latlon) &
## TEMP ## rm -f static/REL_HI.zip; zip -9 --quiet static/REL_HI.zip $(./ziptiles.py -165.00  25.0 -150.00 15.00 rel latlon) &
## TEMP ## rm -f static/REL_PR.zip; zip -9 --quiet static/REL_PR.zip $(./ziptiles.py  -68.00  19.5  -64.00 17.00 rel latlon) &
## TEMP ## rm -f static/REL_NE.zip; zip -9 --quiet static/REL_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 rel latlon) &
## TEMP ## rm -f static/REL_NC.zip; zip -9 --quiet static/REL_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 rel latlon) &
## TEMP ## rm -f static/REL_NW.zip; zip -9 --quiet static/REL_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 rel latlon) &
## TEMP ## rm -f static/REL_SE.zip; zip -9 --quiet static/REL_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 rel latlon) &
## TEMP ## rm -f static/REL_SC.zip; zip -9 --quiet static/REL_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 rel latlon) &
## TEMP ## rm -f static/REL_SW.zip; zip -9 --quiet static/REL_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 rel latlon) &
## TEMP ## wait
## TEMP ## ## echo done relief
## TEMP ## ## 
## TEMP ## ## echo starting terrain
## TEMP ## ## AK Upper Left  (-3327000.000, 2438000.000) (142d44' 7.99"E, 56d30' 7.45"N)
## TEMP ## ## AK Lower Left  (-3327000.000,  346000.000) (163d25'20.02"E, 43d 3'12.40"N)
## TEMP ## ## AK Upper Right ( 1654000.000, 2438000.000) (113d28'58.51"W, 67d12'45.81"N)
## TEMP ## ## AK Lower Right ( 1654000.000,  346000.000) (130d24'21.38"W, 50d26'41.22"N)
## TEMP ## ## AK Center      ( -836500.000, 1392000.000) (169d57'59.56"W, 61d35'50.85"N)
## TEMP ## 
## TEMP ## rm -f static/ELEV_AK.zip; zip -9 static/ELEV_AK.zip $(./ziptiles.py -179.90  75.0 -128.45 50.50 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_HI.zip; zip -9 static/ELEV_HI.zip $(./ziptiles.py -165.00  25.0 -150.00 15.00 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_PR.zip; zip -9 static/ELEV_PR.zip $(./ziptiles.py  -68.00  19.5  -64.00 17.00 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_NE.zip; zip -9 static/ELEV_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_NC.zip; zip -9 static/ELEV_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_NW.zip; zip -9 static/ELEV_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_SE.zip; zip -9 static/ELEV_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_SC.zip; zip -9 static/ELEV_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 elev latlon) &  ## --quiet 
## TEMP ## rm -f static/ELEV_SW.zip; zip -9 static/ELEV_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 elev latlon) &  ## --quiet 
## TEMP ## wait
## TEMP ## 

#rm -f static/ELEV_3D_Coarse_AK.zip; ./cyclenumber.sh > ELEV_3D_Coarse_AK; ./ziptiles.py -179.90  75.0 -128.45 50.50 3dcoarse latlon >> ELEV_3D_Coarse_AK; tail -n+2 ELEV_3D_Coarse_AK | xargs zip -9 static/ELEV_3D_Coarse_AK.zip ELEV_3D_Coarse_AK &  ## --quiet 
#rm -f static/ELEV_3D_Coarse_HI.zip; ./cyclenumber.sh > ELEV_3D_Coarse_HI; ./ziptiles.py -165.00  25.0 -150.00 15.00 3dcoarse latlon >> ELEV_3D_Coarse_HI; tail -n+2 ELEV_3D_Coarse_HI | xargs zip -9 static/ELEV_3D_Coarse_HI.zip ELEV_3D_Coarse_HI &  ## --quiet 
#rm -f static/ELEV_3D_Coarse_PR.zip; ./cyclenumber.sh > ELEV_3D_Coarse_PR; ./ziptiles.py  -68.00  19.5  -64.00 17.00 3dcoarse latlon >> ELEV_3D_Coarse_PR; tail -n+2 ELEV_3D_Coarse_PR | xargs zip -9 static/ELEV_3D_Coarse_PR.zip ELEV_3D_Coarse_PR &  ## --quiet 
rm -f static/ELEV_3D_Coarse_NE.zip; ./cyclenumber.sh > ELEV_3d_Coarse_NE; ./ziptiles.py  -85.00 50.15  -40.00 38.00 3dcoarse latlon >> ELEV_3d_Coarse_NE; tail -n+2 ELEV_3d_Coarse_NE | xargs zip -9 static/ELEV_3D_Coarse_NE.zip ELEV_3d_Coarse_NE &  ## --quiet 
rm -f static/ELEV_3D_Coarse_NC.zip; ./cyclenumber.sh > ELEV_3d_Coarse_NC; ./ziptiles.py -110.00 50.15  -85.00 38.00 3dcoarse latlon >> ELEV_3d_Coarse_NC; tail -n+2 ELEV_3d_Coarse_NC | xargs zip -9 static/ELEV_3D_Coarse_NC.zip ELEV_3d_Coarse_NC &  ## --quiet 
rm -f static/ELEV_3D_Coarse_NW.zip; ./cyclenumber.sh > ELEV_3d_Coarse_NW; ./ziptiles.py -131.21 50.15 -110.00 38.00 3dcoarse latlon >> ELEV_3d_Coarse_NW; tail -n+2 ELEV_3d_Coarse_NW | xargs zip -9 static/ELEV_3D_Coarse_NW.zip ELEV_3d_Coarse_NW &  ## --quiet 
rm -f static/ELEV_3D_Coarse_SE.zip; ./cyclenumber.sh > ELEV_3d_Coarse_SE; ./ziptiles.py  -85.00 38.00  -40.00 23.13 3dcoarse latlon >> ELEV_3d_Coarse_SE; tail -n+2 ELEV_3d_Coarse_SE | xargs zip -9 static/ELEV_3D_Coarse_SE.zip ELEV_3d_Coarse_SE &  ## --quiet 
rm -f static/ELEV_3D_Coarse_SC.zip; ./cyclenumber.sh > ELEV_3d_Coarse_SC; ./ziptiles.py -110.00 38.00  -85.00 23.13 3dcoarse latlon >> ELEV_3d_Coarse_SC; tail -n+2 ELEV_3d_Coarse_SC | xargs zip -9 static/ELEV_3D_Coarse_SC.zip ELEV_3d_Coarse_SC &  ## --quiet 
rm -f static/ELEV_3D_Coarse_SW.zip; ./cyclenumber.sh > ELEV_3d_Coarse_SW; ./ziptiles.py -131.21 38.00 -110.00 23.13 3dcoarse latlon >> ELEV_3d_Coarse_SW; tail -n+2 ELEV_3d_Coarse_SW | xargs zip -9 static/ELEV_3D_Coarse_SW.zip ELEV_3d_Coarse_SW &  ## --quiet 
#
#rm -f static/ELEV_3D_Detail_AK.zip; ./cyclenumber.sh > ELEV_3D_Detail_AK; ./ziptiles.py -179.90  75.0 -128.45 50.50 3ddetail latlon >> ELEV_3D_Detail_AK; tail -n+2 ELEV_3D_Detail_AK | xargs zip -9 static/ELEV_3D_Detail_AK.zip ELEV_3D_Detail_AK &  ## --quiet 
#rm -f static/ELEV_3D_Detail_HI.zip; ./cyclenumber.sh > ELEV_3D_Detail_HI; ./ziptiles.py -165.00  25.0 -150.00 15.00 3ddetail latlon >> ELEV_3D_Detail_HI; tail -n+2 ELEV_3D_Detail_HI | xargs zip -9 static/ELEV_3D_Detail_HI.zip ELEV_3D_Detail_HI &  ## --quiet 
#rm -f static/ELEV_3D_Detail_PR.zip; ./cyclenumber.sh > ELEV_3D_Detail_PR; ./ziptiles.py  -68.00  19.5  -64.00 17.00 3ddetail latlon >> ELEV_3D_Detail_PR; tail -n+2 ELEV_3D_Detail_PR | xargs zip -9 static/ELEV_3D_Detail_PR.zip ELEV_3D_Detail_PR &  ## --quiet 
rm -f static/ELEV_3D_Detail_NE.zip; ./cyclenumber.sh > ELEV_3d_Detail_NE; ./ziptiles.py  -85.00 50.15  -40.00 38.00 3ddetail latlon >> ELEV_3d_Detail_NE; tail -n+2 ELEV_3d_Detail_NE | xargs zip -9 static/ELEV_3D_Detail_NE.zip ELEV_3d_Detail_NE &  ## --quiet 
rm -f static/ELEV_3D_Detail_NC.zip; ./cyclenumber.sh > ELEV_3d_Detail_NC; ./ziptiles.py -110.00 50.15  -85.00 38.00 3ddetail latlon >> ELEV_3d_Detail_NC; tail -n+2 ELEV_3d_Detail_NC | xargs zip -9 static/ELEV_3D_Detail_NC.zip ELEV_3d_Detail_NC &  ## --quiet 
rm -f static/ELEV_3D_Detail_NW.zip; ./cyclenumber.sh > ELEV_3d_Detail_NW; ./ziptiles.py -131.21 50.15 -110.00 38.00 3ddetail latlon >> ELEV_3d_Detail_NW; tail -n+2 ELEV_3d_Detail_NW | xargs zip -9 static/ELEV_3D_Detail_NW.zip ELEV_3d_Detail_NW &  ## --quiet 
rm -f static/ELEV_3D_Detail_SE.zip; ./cyclenumber.sh > ELEV_3d_Detail_SE; ./ziptiles.py  -85.00 38.00  -40.00 23.13 3ddetail latlon >> ELEV_3d_Detail_SE; tail -n+2 ELEV_3d_Detail_SE | xargs zip -9 static/ELEV_3D_Detail_SE.zip ELEV_3d_Detail_SE &  ## --quiet 
rm -f static/ELEV_3D_Detail_SC.zip; ./cyclenumber.sh > ELEV_3d_Detail_SC; ./ziptiles.py -110.00 38.00  -85.00 23.13 3ddetail latlon >> ELEV_3d_Detail_SC; tail -n+2 ELEV_3d_Detail_SC | xargs zip -9 static/ELEV_3D_Detail_SC.zip ELEV_3d_Detail_SC &  ## --quiet 
rm -f static/ELEV_3D_Detail_SW.zip; ./cyclenumber.sh > ELEV_3d_Detail_SW; ./ziptiles.py -131.21 38.00 -110.00 23.13 3ddetail latlon >> ELEV_3d_Detail_SW; tail -n+2 ELEV_3d_Detail_SW | xargs zip -9 static/ELEV_3D_Detail_SW.zip ELEV_3d_Detail_SW &  ## --quiet 
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
