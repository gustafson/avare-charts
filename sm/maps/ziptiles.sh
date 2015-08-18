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
    ## echo $1 $2
    ## echo ./ziptiles.py $(extract_corners.sh $1) $(cyclenumber.sh) $2 meters
    ./ziptiles.py $(extract_corners.sh $1) $(cyclenumber.sh) $2 meters
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

rm -f final/ELUS_AK.zip; zip -9 --quiet final/ELUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_NE.zip; zip -9 --quiet final/ELUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_NC.zip; zip -9 --quiet final/ELUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_NW.zip; zip -9 --quiet final/ELUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifr latlon) &
rm -f final/ELUS_SE.zip; zip -9 --quiet final/ELUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifr latlon) &
rm -f final/ELUS_SC.zip; zip -9 --quiet final/ELUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifr latlon) &
rm -f final/ELUS_SW.zip; zip -9 --quiet final/ELUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifr latlon) &

rm -f final/EHUS_AK.zip; zip -9 --quiet final/EHUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_NE.zip; zip -9 --quiet final/EHUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_NC.zip; zip -9 --quiet final/EHUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_NW.zip; zip -9 --quiet final/EHUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} ifh latlon) &
rm -f final/EHUS_SE.zip; zip -9 --quiet final/EHUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} ifh latlon) &
rm -f final/EHUS_SC.zip; zip -9 --quiet final/EHUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} ifh latlon) &
rm -f final/EHUS_SW.zip; zip -9 --quiet final/EHUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} ifh latlon) &
wait
echo done ifr

echo starting relief
## DANGEROUS SHORT TERM FIX ## pushd ../usgs/sr/
## DANGEROUS SHORT TERM FIX ## for a in REL_{AK,HI,PR}.zip; do
## DANGEROUS SHORT TERM FIX ##     unzip $a
## DANGEROUS SHORT TERM FIX ##     mv tiles/1* tiles/${CYCLE}
## DANGEROUS SHORT TERM FIX ##     rm $a
## DANGEROUS SHORT TERM FIX ##     zip -9 $a `find tiles/${CYCLE} -name "*jpg"`
## DANGEROUS SHORT TERM FIX ##     rm -r tiles
## DANGEROUS SHORT TERM FIX ## done
## DANGEROUS SHORT TERM FIX ## popd
## DANGEROUS SHORT TERM FIX ## cp ../usgs/sr/REL_{AK,HI,PR}.zip final/.
rm -f final/REL_NE.zip; zip -9 --quiet final/REL_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} rel latlon) &
rm -f final/REL_NC.zip; zip -9 --quiet final/REL_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} rel latlon) &
rm -f final/REL_NW.zip; zip -9 --quiet final/REL_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} rel latlon) &
rm -f final/REL_SE.zip; zip -9 --quiet final/REL_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} rel latlon) &
rm -f final/REL_SC.zip; zip -9 --quiet final/REL_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} rel latlon) &
rm -f final/REL_SW.zip; zip -9 --quiet final/REL_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} rel latlon) &
wait
echo done relief

echo starting terrain
## DANGEROUS SHORT TERM FIX ## pushd ../usgs/terrain
## DANGEROUS SHORT TERM FIX ## for a in ELEV_{AK,HI,PR}.zip; do
## DANGEROUS SHORT TERM FIX ##     unzip $a
## DANGEROUS SHORT TERM FIX ##     mv tiles/1* tiles/${CYCLE}
## DANGEROUS SHORT TERM FIX ##     rm $a
## DANGEROUS SHORT TERM FIX ##     zip -9 $a `find tiles/${CYCLE} -name "*png"`
## DANGEROUS SHORT TERM FIX ##     rm -r tiles
## DANGEROUS SHORT TERM FIX ## done
## DANGEROUS SHORT TERM FIX ## popd
## DANGEROUS SHORT TERM FIX ## cp ../usgs/terrain/ELEV_{AK,HI,PR}.zip final/.
rm -f final/ELEV_NE.zip; zip -9 final/ELEV_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ${CYCLE} elev latlon) &  ## --quiet 
rm -f final/ELEV_NC.zip; zip -9 final/ELEV_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ${CYCLE} elev latlon) &  ## --quiet 
rm -f final/ELEV_NW.zip; zip -9 final/ELEV_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ${CYCLE} elev latlon) &  ## --quiet 
rm -f final/ELEV_SE.zip; zip -9 final/ELEV_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ${CYCLE} elev latlon) &  ## --quiet 
rm -f final/ELEV_SC.zip; zip -9 final/ELEV_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ${CYCLE} elev latlon) &  ## --quiet 
rm -f final/ELEV_SW.zip; zip -9 final/ELEV_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ${CYCLE} elev latlon) &  ## --quiet 
wait
echo done terrain

echo starting heli
## Heli
for img in `ls merge/heli/*2.vrt|grep -v North|grep -v South|grep -v East|grep -v West|grep -v NewYork_2` merge/heli/*3.vrt; do
    IMG=`echo $img | cut -d\/ -f3 | sed 's/.\{6\}$//'`
    if [[ ${IMG:0:11} == GrandCanyon ]]; then
	IMBASE=${IMG:0:11};
    else
	IMBASE=${IMG}Heli
    fi
    BASE=final/${IMBASE}.zip
    rm -f $BASE
    FILE=`find merge/heli/${IMG}*|grep 3`
    if [[ -f ${FILE} ]]; then
	#echo `ls merge/heli/${IMG}*3.vrt`
	zip -9 --quiet $BASE $(./ziptiles.py `./extract_corners.sh merge/heli/${IMG}*3.vrt` ${CYCLE} heli meters) &
    else
	#echo `ls merge/heli/${IMG}*2.vrt`
	zip -9 --quiet $BASE $(./ziptiles.py `./extract_corners.sh merge/heli/${IMG}*2.vrt` ${CYCLE} heli meters) &
    fi
done
wait
echo done heli


## make zipit
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} sec latlon|grep "tiles/..../0/7"`   ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} tac latlon|grep "tiles/..../1/8"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} wac latlon|grep "tiles/..../2/6"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} ifr latlon|grep "tiles/..../3/7"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} ifh latlon|grep "tiles/..../4/6"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} ifa latlon|grep "tiles/..../5/8"`	  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} elev latlon|grep "tiles/..../6/6"`  ## --quiet 
## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ${CYCLE} rel latlon|grep "tiles/..../7/6"`	  ## --quiet 
## echo done databases

echo start Candian topo
for img in `ls ../can-topo/[0-9]*vrt`; do
    base=`echo $img|cut -f3 -d/|cut -f1 -d.`
    [[ -f final/CAN_${base}.zip ]] && rm final/CAN_${base}.zip
    echo final/CAN_${base}.zip
    zip -9 --quiet final/CAN_${base}.zip `mygroup ${img} topo`
done
wait
echo done topo

## Now create manifest
pushd final
rm -f ../tiledatabase.txt
for a in *zip; do
    b=`basename $a .zip`;
    #zip -d $a $b
    #../zip.py `basename ${a} .zip` ${CYCLE};
    unzip -l ${a} |grep tiles/${CYCLE}/./8 | cut -f 3- -d/ | cut -f1 -d. |
	while read img; do
	    echo "${b},${img}" >> ../tiledatabase.txt
	done
done
popd

## Now create tile lookup database
rm -f tiles.db
cat << EOF  | sqlite3 tiles.db
CREATE TABLE tiles(zip Text,tile Text);
.separator ','
.import tiledatabase.txt tiles
EOF
