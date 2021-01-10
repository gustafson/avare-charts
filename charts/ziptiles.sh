#!/bin/sh -login
#PBS -l mem=20gb
#PBS -l nodes=1:ppn=16
#PBS -l walltime=1000:00:00
#PBS -m abe 
#PBS -V 
#PBS -N ziptiles
#PBS -e z-logs/z.${PBS_JOBID}.e_${PBS_JOBNAME}
#PBS -o z-logs/z.${PBS_JOBID}.o_${PBS_JOBNAME}
#PBS -t 0-5%1

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

if [[ ${PBS_NODEFILE} ]]; then
    echo ------------------------------------------------------
    NODE=`sort ${PBS_NODEFILE} | uniq`
    HOST=`echo ${PBS_O_HOST} |cut -f1 -d.`
    echo Job is running on node ${NODE} from host ${HOST}
    echo ------------------------------------------------------
    echo PBS: qsub was run on ${PBS_O_HOST}
    echo PBS: originating queue is ${PBS_O_QUEUE}
    echo PBS: executing queue is ${PBS_QUEUE}
    echo PBS: working directory is ${PBS_O_WORKDIR}
    echo PBS: execution mode is ${PBS_ENVIRONMENT}
    echo PBS: job identifier is ${PBS_JOBID}
    echo PBS: job name is ${PBS_JOBNAME}
    echo PBS: node file is ${PBS_NODEFILE}
    echo PBS: current home directory is ${PBS_O_HOME}
    echo PBS: PATH = ${PBS_O_PATH}
    echo ------------------------------------------------------

    NP=$(cat ${PBS_NODEFILE} | wc -l)
    export TMPDIR=/scratch
else
    NP=16
    export TMPDIR=/data/home/pi/gustafson
fi

[[ ${PBS_O_WORKDIR} ]] && cd ${PBS_O_WORKDIR}

function mygroup(){
    # echo $1 $2
    corners=`extract_corners.sh $1`
    ./ziptiles.py $corners $2 meters $3
}

export -f mygroup
CYCLE=$(cyclenumber.py)

function rmemptypng(){
    ## echo $0
    [[ `convert $0 -format '%@' info: 2> /dev/null|cut -c 1-3` == "0x0" ]] && rm $0
}
export -f rmemptypng

function cleanmebylatlon () {
    #echo $1 $2 $3 $4 $5 $6
    echo $(./ziptiles.py $1 $2 $3 $4 $5 $6)  | xargs -n1 -P16 bash -c rmemptypng
    echo $(./ziptiles.py $1 $2 $3 $4 $5 $6)  | xargs mogrify -format png8
    echo $(./ziptiles.py $1 $2 $3 $4 $5 $6)  | sed s/png/png8/ | xargs rename png8 png
    echo $(./ziptiles.py $1 $2 $3 $4 $5 $6)  | xargs -n1 -P16 optipng
}

function cleanmebyimage () {
    mygroup $1 $2 | xargs -n1 -P16 bash -c rmemptypng
    mygroup $1 $2 | xargs mogrify -format png8
    mygroup $1 $2 | sed s/png/png8/ | xargs rename png8 png
    mygroup $1 $2 | xargs -n1 -P16 optipng
}
export -f cleanmebylatlon
export -f cleanmebyimage

if [[ ${PBS_ARRAYID} -eq 0 ]]; then

    ## echo starting vfr
    for img in `ls merge/sec/*_c.vrt`; do
    	BASE=final/`echo $img | cut -f3 -d/ | cut -c 3-|cut -f1 -d_`.zip
    	rm -f $BASE
    	echo $BASE
    	zip -9 --quiet $BASE `mygroup ${img} sec 512` &
    done

    for img in `ls merge/sec/*_c.vrt`; do
	rm -f final/${base}-256.zip
	cleanmebyimage ${img} ifa 
    done
    wait
    
elif [[ ${PBS_ARRAYID} -eq 1 ]]; then
    ## for img in `ls merge/wac/*_c.vrt`; do
    ##     BASE=final/`echo $img | cut -f3 -d/ | cut -c 3-|cut -f1 -d_`.zip
    ##     rm -fr $BASE
    ##     echo $BASE
    ##     zip -9 --quiet $BASE `mygroup ${img} wac` &
    ## done
    wait

elif [[ ${PBS_ARRAYID} -eq 2 ]]; then
    ## for img in `ls merge/tac/*_c.vrt`; do
    ## 	BASE=final/`echo $img | cut -f3 -d/ | cut -c 4-|cut -f1 -d_`.zip
    ## 	rm -f $BASE
    ## 	echo $BASE
    ## 	zip -9 --quiet $BASE `mygroup ${img} tac` &
    ## done
    wait

elif [[ ${PBS_ARRAYID} -eq 3 ]]; then
    
    ## cleanmebylatlon -179.90  75.0 -128.45 50.50 ifr latlon
    ## cleanmebylatlon -165.00  25.0 -150.00 15.00 ifr latlon
    ## cleanmebylatlon  -68.00  19.5  -64.00 17.00 ifr latlon
    ## cleanmebylatlon  -85.00 50.15  -40.00 38.00 ifr latlon
    ## cleanmebylatlon -110.00 50.15  -85.00 38.00 ifr latlon
    ## cleanmebylatlon -131.21 50.15 -110.00 38.00 ifr latlon
    ## cleanmebylatlon  -85.00 38.00  -40.00 23.13 ifr latlon
    ## cleanmebylatlon -110.00 38.00  -85.00 23.13 ifr latlon
    ## cleanmebylatlon -131.21 38.00 -110.00 23.13 ifr latlon
    
    wait
    rm -f final/ELUS_AK-256.zip; echo ${CYCLE} > ELUS_AK-256; ./ziptiles.py -179.90  75.0 -128.45 50.50 ifr latlon >> ELUS_AK-256; tail -n+2 ELUS_AK-256 |xargs zip -9 final/ELUS_AK-256.zip ELUS_AK-256 &  ## --quiet 
    rm -f final/ELUS_HI-256.zip; echo ${CYCLE} > ELUS_HI-256; ./ziptiles.py -165.00  25.0 -150.00 15.00 ifr latlon >> ELUS_HI-256; tail -n+2 ELUS_HI-256 |xargs zip -9 final/ELUS_HI-256.zip ELUS_HI-256 &  ## --quiet 
    rm -f final/ELUS_PR-256.zip; echo ${CYCLE} > ELUS_PR-256; ./ziptiles.py  -68.00  19.5  -64.00 17.00 ifr latlon >> ELUS_PR-256; tail -n+2 ELUS_PR-256 |xargs zip -9 final/ELUS_PR-256.zip ELUS_PR-256 &  ## --quiet 
    rm -f final/ELUS_NE-256.zip; echo ${CYCLE} > ELUS_NE-256; ./ziptiles.py  -85.00 50.15  -40.00 38.00 ifr latlon >> ELUS_NE-256; tail -n+2 ELUS_NE-256 |xargs zip -9 final/ELUS_NE-256.zip ELUS_NE-256 &  ## --quiet 
    rm -f final/ELUS_NC-256.zip; echo ${CYCLE} > ELUS_NC-256; ./ziptiles.py -110.00 50.15  -85.00 38.00 ifr latlon >> ELUS_NC-256; tail -n+2 ELUS_NC-256 |xargs zip -9 final/ELUS_NC-256.zip ELUS_NC-256 &  ## --quiet 
    rm -f final/ELUS_NW-256.zip; echo ${CYCLE} > ELUS_NW-256; ./ziptiles.py -131.21 50.15 -110.00 38.00 ifr latlon >> ELUS_NW-256; tail -n+2 ELUS_NW-256 |xargs zip -9 final/ELUS_NW-256.zip ELUS_NW-256 &  ## --quiet 
    rm -f final/ELUS_SE-256.zip; echo ${CYCLE} > ELUS_SE-256; ./ziptiles.py  -85.00 38.00  -40.00 23.13 ifr latlon >> ELUS_SE-256; tail -n+2 ELUS_SE-256 |xargs zip -9 final/ELUS_SE-256.zip ELUS_SE-256 &  ## --quiet 
    rm -f final/ELUS_SC-256.zip; echo ${CYCLE} > ELUS_SC-256; ./ziptiles.py -110.00 38.00  -85.00 23.13 ifr latlon >> ELUS_SC-256; tail -n+2 ELUS_SC-256 |xargs zip -9 final/ELUS_SC-256.zip ELUS_SC-256 &  ## --quiet 
    rm -f final/ELUS_SW-256.zip; echo ${CYCLE} > ELUS_SW-256; ./ziptiles.py -131.21 38.00 -110.00 23.13 ifr latlon >> ELUS_SW-256; tail -n+2 ELUS_SW-256 |xargs zip -9 final/ELUS_SW-256.zip ELUS_SW-256 &  ## --quiet 

    rm -f final/ELUS_AK.zip; zip -9 --quiet final/ELUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ifr latlon 512) &
    rm -f final/ELUS_NE.zip; zip -9 --quiet final/ELUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ifr latlon 512) &
    rm -f final/ELUS_NC.zip; zip -9 --quiet final/ELUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ifr latlon 512) &
    rm -f final/ELUS_NW.zip; zip -9 --quiet final/ELUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ifr latlon 512) &
    rm -f final/ELUS_SE.zip; zip -9 --quiet final/ELUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ifr latlon 512) &
    rm -f final/ELUS_SC.zip; zip -9 --quiet final/ELUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ifr latlon 512) &
    rm -f final/ELUS_SW.zip; zip -9 --quiet final/ELUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ifr latlon 512) &

    wait

elif [[ ${PBS_ARRAYID} -eq 4 ]]; then

    ## cleanmebylatlon -179.90  75.0 -128.45 50.50 ifh latlon
    ## cleanmebylatlon -165.00  25.0 -150.00 15.00 ifh latlon
    ## cleanmebylatlon  -68.00  19.5  -64.00 17.00 ifh latlon
    ## cleanmebylatlon  -85.00 50.15  -40.00 38.00 ifh latlon
    ## cleanmebylatlon -110.00 50.15  -85.00 38.00 ifh latlon
    ## cleanmebylatlon -131.21 50.15 -110.00 38.00 ifh latlon
    ## cleanmebylatlon  -85.00 38.00  -40.00 23.13 ifh latlon
    ## cleanmebylatlon -110.00 38.00  -85.00 23.13 ifh latlon
    ## cleanmebylatlon -131.21 38.00 -110.00 23.13 ifh latlon
    
    wait
    rm -f final/EHUS_AK-256.zip; echo ${CYCLE} > EHUS_AK-256; ./ziptiles.py -179.90  75.0 -128.45 50.50 ifh latlon >> EHUS_AK-256; tail -n+2 EHUS_AK-256 |xargs zip -9 final/EHUS_AK-256.zip EHUS_AK-256 &  ## --quiet 
    rm -f final/EHUS_HI-256.zip; echo ${CYCLE} > EHUS_HI-256; ./ziptiles.py -165.00  25.0 -150.00 15.00 ifh latlon >> EHUS_HI-256; tail -n+2 EHUS_HI-256 |xargs zip -9 final/EHUS_HI-256.zip EHUS_HI-256 &  ## --quiet 
    rm -f final/EHUS_PR-256.zip; echo ${CYCLE} > EHUS_PR-256; ./ziptiles.py  -68.00  19.5  -64.00 17.00 ifh latlon >> EHUS_PR-256; tail -n+2 EHUS_PR-256 |xargs zip -9 final/EHUS_PR-256.zip EHUS_PR-256 &  ## --quiet 
    rm -f final/EHUS_NE-256.zip; echo ${CYCLE} > EHUS_NE-256; ./ziptiles.py  -85.00 50.15  -40.00 38.00 ifh latlon >> EHUS_NE-256; tail -n+2 EHUS_NE-256 |xargs zip -9 final/EHUS_NE-256.zip EHUS_NE-256 &  ## --quiet 
    rm -f final/EHUS_NC-256.zip; echo ${CYCLE} > EHUS_NC-256; ./ziptiles.py -110.00 50.15  -85.00 38.00 ifh latlon >> EHUS_NC-256; tail -n+2 EHUS_NC-256 |xargs zip -9 final/EHUS_NC-256.zip EHUS_NC-256 &  ## --quiet 
    rm -f final/EHUS_NW-256.zip; echo ${CYCLE} > EHUS_NW-256; ./ziptiles.py -131.21 50.15 -110.00 38.00 ifh latlon >> EHUS_NW-256; tail -n+2 EHUS_NW-256 |xargs zip -9 final/EHUS_NW-256.zip EHUS_NW-256 &  ## --quiet 
    rm -f final/EHUS_SE-256.zip; echo ${CYCLE} > EHUS_SE-256; ./ziptiles.py  -85.00 38.00  -40.00 23.13 ifh latlon >> EHUS_SE-256; tail -n+2 EHUS_SE-256 |xargs zip -9 final/EHUS_SE-256.zip EHUS_SE-256 &  ## --quiet 
    rm -f final/EHUS_SC-256.zip; echo ${CYCLE} > EHUS_SC-256; ./ziptiles.py -110.00 38.00  -85.00 23.13 ifh latlon >> EHUS_SC-256; tail -n+2 EHUS_SC-256 |xargs zip -9 final/EHUS_SC-256.zip EHUS_SC-256 &  ## --quiet 
    rm -f final/EHUS_SW-256.zip; echo ${CYCLE} > EHUS_SW-256; ./ziptiles.py -131.21 38.00 -110.00 23.13 ifh latlon >> EHUS_SW-256; tail -n+2 EHUS_SW-256 |xargs zip -9 final/EHUS_SW-256.zip EHUS_SW-256 &  ## --quiet 

    
    rm -f final/EHUS_AK.zip; zip -9 --quiet final/EHUS_AK.zip $(./ziptiles.py -180.00 75.00 -125.00 50.00 ifh latlon 512) &
    rm -f final/EHUS_NE.zip; zip -9 --quiet final/EHUS_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 ifh latlon 512) &
    rm -f final/EHUS_NC.zip; zip -9 --quiet final/EHUS_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 ifh latlon 512) &
    rm -f final/EHUS_NW.zip; zip -9 --quiet final/EHUS_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 ifh latlon 512) &
    rm -f final/EHUS_SE.zip; zip -9 --quiet final/EHUS_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 ifh latlon 512) &
    rm -f final/EHUS_SC.zip; zip -9 --quiet final/EHUS_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 ifh latlon 512) &
    rm -f final/EHUS_SW.zip; zip -9 --quiet final/EHUS_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 ifh latlon 512) &

    wait

elif [[ ${PBS_ARRAYID} -eq 5 ]]; then

    echo starting ifr
    ## IFR AREA Tiles
    for img in merge/ifa/*vrt; do
    	base=ENRA_`echo ${img} | cut -f3 -d/|cut -f3 -d_|cut -f1 -d.`
    	rm -f final/${base}.zip
    	zip -9 --quiet final/${base}.zip `mygroup ${img} ifa 512` &
    done
    wait

    for img in merge/ifa/*vrt; do
    	base=ENRA_`echo ${img} | cut -f3 -d/|cut -f3 -d_|cut -f1 -d.`
    	rm -f final/${base}-256.zip
	cleanmebyimage ${img} ifa 
	echo ${CYCLE} > ${base}
    	zip -9 --quiet final/${base}-256.zip `mygroup ${img} ifa` &
    done


elif [[ ${PBS_ARRAYID} -eq 6 ]]; then

    ## 
    ## TEMP ## ## echo starting terrain
    ## TEMP ## ## AK Upper Left  (-3327000.000, 2438000.000) (142d44' 7.99"E, 56d30' 7.45"N)
    ## TEMP ## ## AK Lower Left  (-3327000.000,  346000.000) (163d25'20.02"E, 43d 3'12.40"N)
    ## TEMP ## ## AK Upper Right ( 1654000.000, 2438000.000) (113d28'58.51"W, 67d12'45.81"N)
    ## TEMP ## ## AK Lower Right ( 1654000.000,  346000.000) (130d24'21.38"W, 50d26'41.22"N)
    ## TEMP ## ## AK Center      ( -836500.000, 1392000.000) (169d57'59.56"W, 61d35'50.85"N)

    ## cleanmebylatlon -179.90  75.0 -128.45 50.50 elev latlon
    ## cleanmebylatlon -165.00  25.0 -150.00 15.00 elev latlon
    ## cleanmebylatlon  -68.00  19.5  -64.00 17.00 elev latlon
    ## cleanmebylatlon  -85.00 50.15  -40.00 38.00 elev latlon
    ## cleanmebylatlon -110.00 50.15  -85.00 38.00 elev latlon
    ## cleanmebylatlon -131.21 50.15 -110.00 38.00 elev latlon
    ## cleanmebylatlon  -85.00 38.00  -40.00 23.13 elev latlon
    ## cleanmebylatlon -110.00 38.00  -85.00 23.13 elev latlon
    ## cleanmebylatlon -131.21 38.00 -110.00 23.13 elev latlon

    ## rm -f static/ELEV_AK_COARSE-256.zip; echo ${CYCLE} > ELEV_AK_COARSE-256; ./ziptiles.py -179.90  75.0 -128.45 50.50 elev latlon >> ELEV_AK_COARSE-256; tail -n+2 ELEV_AK_COARSE-256 |xargs zip -9 static/ELEV_AK_COARSE-256.zip ELEV_AK_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_HI_COARSE-256.zip; echo ${CYCLE} > ELEV_HI_COARSE-256; ./ziptiles.py -165.00  25.0 -150.00 15.00 elev latlon >> ELEV_HI_COARSE-256; tail -n+2 ELEV_HI_COARSE-256 |xargs zip -9 static/ELEV_HI_COARSE-256.zip ELEV_HI_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_PR_COARSE-256.zip; echo ${CYCLE} > ELEV_PR_COARSE-256; ./ziptiles.py  -68.00  19.5  -64.00 17.00 elev latlon >> ELEV_PR_COARSE-256; tail -n+2 ELEV_PR_COARSE-256 |xargs zip -9 static/ELEV_PR_COARSE-256.zip ELEV_PR_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_NE_COARSE-256.zip; echo ${CYCLE} > ELEV_NE_COARSE-256; ./ziptiles.py  -85.00 50.15  -40.00 38.00 elev latlon >> ELEV_NE_COARSE-256; tail -n+2 ELEV_NE_COARSE-256 |xargs zip -9 static/ELEV_NE_COARSE-256.zip ELEV_NE_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_NC_COARSE-256.zip; echo ${CYCLE} > ELEV_NC_COARSE-256; ./ziptiles.py -110.00 50.15  -85.00 38.00 elev latlon >> ELEV_NC_COARSE-256; tail -n+2 ELEV_NC_COARSE-256 |xargs zip -9 static/ELEV_NC_COARSE-256.zip ELEV_NC_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_NW_COARSE-256.zip; echo ${CYCLE} > ELEV_NW_COARSE-256; ./ziptiles.py -131.21 50.15 -110.00 38.00 elev latlon >> ELEV_NW_COARSE-256; tail -n+2 ELEV_NW_COARSE-256 |xargs zip -9 static/ELEV_NW_COARSE-256.zip ELEV_NW_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_SE_COARSE-256.zip; echo ${CYCLE} > ELEV_SE_COARSE-256; ./ziptiles.py  -85.00 38.00  -40.00 23.13 elev latlon >> ELEV_SE_COARSE-256; tail -n+2 ELEV_SE_COARSE-256 |xargs zip -9 static/ELEV_SE_COARSE-256.zip ELEV_SE_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_SC_COARSE-256.zip; echo ${CYCLE} > ELEV_SC_COARSE-256; ./ziptiles.py -110.00 38.00  -85.00 23.13 elev latlon >> ELEV_SC_COARSE-256; tail -n+2 ELEV_SC_COARSE-256 |xargs zip -9 static/ELEV_SC_COARSE-256.zip ELEV_SC_COARSE-256 &  ## --quiet 
    ## rm -f static/ELEV_SW_COARSE-256.zip; echo ${CYCLE} > ELEV_SW_COARSE-256; ./ziptiles.py -131.21 38.00 -110.00 23.13 elev latlon >> ELEV_SW_COARSE-256; tail -n+2 ELEV_SW_COARSE-256 |xargs zip -9 static/ELEV_SW_COARSE-256.zip ELEV_SW_COARSE-256 &  ## --quiet 

    wait

    ## TEMP ## 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_AK.zip; ./cyclenumber.py > ELEV_3D_Coarse_AK; ./ziptiles.py -179.90  75.0 -128.45 50.50 3dcoarse latlon >> ELEV_3D_Coarse_AK; tail -n+2 ELEV_3D_Coarse_AK | xargs zip -9 static/ELEV_3D_Coarse_AK.zip ELEV_3D_Coarse_AK &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_HI.zip; ./cyclenumber.py > ELEV_3D_Coarse_HI; ./ziptiles.py -165.00  25.0 -150.00 15.00 3dcoarse latlon >> ELEV_3D_Coarse_HI; tail -n+2 ELEV_3D_Coarse_HI | xargs zip -9 static/ELEV_3D_Coarse_HI.zip ELEV_3D_Coarse_HI &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_PR.zip; ./cyclenumber.py > ELEV_3D_Coarse_PR; ./ziptiles.py  -68.00  19.5  -64.00 17.00 3dcoarse latlon >> ELEV_3D_Coarse_PR; tail -n+2 ELEV_3D_Coarse_PR | xargs zip -9 static/ELEV_3D_Coarse_PR.zip ELEV_3D_Coarse_PR &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_NE.zip; ./cyclenumber.py > ELEV_3d_Coarse_NE; ./ziptiles.py  -85.00 50.15  -40.00 38.00 3dcoarse latlon >> ELEV_3d_Coarse_NE; tail -n+2 ELEV_3d_Coarse_NE | xargs zip -9 static/ELEV_3D_Coarse_NE.zip ELEV_3d_Coarse_NE &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_NC.zip; ./cyclenumber.py > ELEV_3d_Coarse_NC; ./ziptiles.py -110.00 50.15  -85.00 38.00 3dcoarse latlon >> ELEV_3d_Coarse_NC; tail -n+2 ELEV_3d_Coarse_NC | xargs zip -9 static/ELEV_3D_Coarse_NC.zip ELEV_3d_Coarse_NC &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_NW.zip; ./cyclenumber.py > ELEV_3d_Coarse_NW; ./ziptiles.py -131.21 50.15 -110.00 38.00 3dcoarse latlon >> ELEV_3d_Coarse_NW; tail -n+2 ELEV_3d_Coarse_NW | xargs zip -9 static/ELEV_3D_Coarse_NW.zip ELEV_3d_Coarse_NW &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_SE.zip; ./cyclenumber.py > ELEV_3d_Coarse_SE; ./ziptiles.py  -85.00 38.00  -40.00 23.13 3dcoarse latlon >> ELEV_3d_Coarse_SE; tail -n+2 ELEV_3d_Coarse_SE | xargs zip -9 static/ELEV_3D_Coarse_SE.zip ELEV_3d_Coarse_SE &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_SC.zip; ./cyclenumber.py > ELEV_3d_Coarse_SC; ./ziptiles.py -110.00 38.00  -85.00 23.13 3dcoarse latlon >> ELEV_3d_Coarse_SC; tail -n+2 ELEV_3d_Coarse_SC | xargs zip -9 static/ELEV_3D_Coarse_SC.zip ELEV_3d_Coarse_SC &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Coarse_SW.zip; ./cyclenumber.py > ELEV_3d_Coarse_SW; ./ziptiles.py -131.21 38.00 -110.00 23.13 3dcoarse latlon >> ELEV_3d_Coarse_SW; tail -n+2 ELEV_3d_Coarse_SW | xargs zip -9 static/ELEV_3D_Coarse_SW.zip ELEV_3d_Coarse_SW &  ## --quiet 
    ## TEMP ## #
    ## TEMP ## #rm -f static/ELEV_3D_Detail_AK.zip; ./cyclenumber.py > ELEV_3D_Detail_AK; ./ziptiles.py -179.90  75.0 -128.45 50.50 3ddetail latlon >> ELEV_3D_Detail_AK; tail -n+2 ELEV_3D_Detail_AK | xargs zip -9 static/ELEV_3D_Detail_AK.zip ELEV_3D_Detail_AK &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_HI.zip; ./cyclenumber.py > ELEV_3D_Detail_HI; ./ziptiles.py -165.00  25.0 -150.00 15.00 3ddetail latlon >> ELEV_3D_Detail_HI; tail -n+2 ELEV_3D_Detail_HI | xargs zip -9 static/ELEV_3D_Detail_HI.zip ELEV_3D_Detail_HI &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_PR.zip; ./cyclenumber.py > ELEV_3D_Detail_PR; ./ziptiles.py  -68.00  19.5  -64.00 17.00 3ddetail latlon >> ELEV_3D_Detail_PR; tail -n+2 ELEV_3D_Detail_PR | xargs zip -9 static/ELEV_3D_Detail_PR.zip ELEV_3D_Detail_PR &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_NE.zip; ./cyclenumber.py > ELEV_3d_Detail_NE; ./ziptiles.py  -85.00 50.15  -40.00 38.00 3ddetail latlon >> ELEV_3d_Detail_NE; tail -n+2 ELEV_3d_Detail_NE | xargs zip -9 static/ELEV_3D_Detail_NE.zip ELEV_3d_Detail_NE &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_NC.zip; ./cyclenumber.py > ELEV_3d_Detail_NC; ./ziptiles.py -110.00 50.15  -85.00 38.00 3ddetail latlon >> ELEV_3d_Detail_NC; tail -n+2 ELEV_3d_Detail_NC | xargs zip -9 static/ELEV_3D_Detail_NC.zip ELEV_3d_Detail_NC &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_NW.zip; ./cyclenumber.py > ELEV_3d_Detail_NW; ./ziptiles.py -131.21 50.15 -110.00 38.00 3ddetail latlon >> ELEV_3d_Detail_NW; tail -n+2 ELEV_3d_Detail_NW | xargs zip -9 static/ELEV_3D_Detail_NW.zip ELEV_3d_Detail_NW &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_SE.zip; ./cyclenumber.py > ELEV_3d_Detail_SE; ./ziptiles.py  -85.00 38.00  -40.00 23.13 3ddetail latlon >> ELEV_3d_Detail_SE; tail -n+2 ELEV_3d_Detail_SE | xargs zip -9 static/ELEV_3D_Detail_SE.zip ELEV_3d_Detail_SE &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_SC.zip; ./cyclenumber.py > ELEV_3d_Detail_SC; ./ziptiles.py -110.00 38.00  -85.00 23.13 3ddetail latlon >> ELEV_3d_Detail_SC; tail -n+2 ELEV_3d_Detail_SC | xargs zip -9 static/ELEV_3D_Detail_SC.zip ELEV_3d_Detail_SC &  ## --quiet 
    ## TEMP ## #rm -f static/ELEV_3D_Detail_SW.zip; ./cyclenumber.py > ELEV_3d_Detail_SW; ./ziptiles.py -131.21 38.00 -110.00 23.13 3ddetail latlon >> ELEV_3d_Detail_SW; tail -n+2 ELEV_3d_Detail_SW | xargs zip -9 static/ELEV_3D_Detail_SW.zip ELEV_3d_Detail_SW &  ## --quiet 
    ## TEMP ## #wait
    ## TEMP ## 
    ## TEMP ## ## echo done terrain

elif [[ ${PBS_ARRAYID} -eq 7 ]]; then
    
    ## echo starting relief
    rm -f static/REL_AK.zip; zip -9 --quiet static/REL_AK.zip $(./ziptiles.py -179.90  75.0 -128.45 50.50 rel latlon 512) &
    rm -f static/REL_HI.zip; zip -9 --quiet static/REL_HI.zip $(./ziptiles.py -165.00  25.0 -150.00 15.00 rel latlon 512) &
    rm -f static/REL_PR.zip; zip -9 --quiet static/REL_PR.zip $(./ziptiles.py  -68.00  19.5  -64.00 17.00 rel latlon 512) &
    rm -f static/REL_NE.zip; zip -9 --quiet static/REL_NE.zip $(./ziptiles.py  -85.00 50.15  -40.00 38.00 rel latlon 512) &
    rm -f static/REL_NC.zip; zip -9 --quiet static/REL_NC.zip $(./ziptiles.py -110.00 50.15  -85.00 38.00 rel latlon 512) &
    rm -f static/REL_NW.zip; zip -9 --quiet static/REL_NW.zip $(./ziptiles.py -131.21 50.15 -110.00 38.00 rel latlon 512) &
    rm -f static/REL_SE.zip; zip -9 --quiet static/REL_SE.zip $(./ziptiles.py  -85.00 38.00  -40.00 23.13 rel latlon 512) &
    rm -f static/REL_SC.zip; zip -9 --quiet static/REL_SC.zip $(./ziptiles.py -110.00 38.00  -85.00 23.13 rel latlon 512) &
    rm -f static/REL_SW.zip; zip -9 --quiet static/REL_SW.zip $(./ziptiles.py -131.21 38.00 -110.00 23.13 rel latlon 512) &
    wait

elif [[ ${PBS_ARRAYID} -eq 8 ]]; then

    echo start Candian topo
    for img in `ls ../can-topo/[0-9]*vrt`; do
	base=`echo $img|cut -f3 -d/|cut -f1 -d.`
	[[ -f final/CAN_${base}.zip ]] && rm final/CAN_${base}.zip
	echo final/CAN_${base}.zip
	zip -9 --quiet final/CAN_${base}.zip `mygroup ${img} topo`
    done
    wait
    echo done topo

elif [[ ${PBS_ARRAYID} -eq 9 ]]; then

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
	    zip -9 --quiet $BASE $(./ziptiles.py `./extract_corners.sh merge/heli/${IMG}*3.vrt` heli meters) &
	else
	    #echo `ls merge/heli/${IMG}*2.vrt`
	    zip -9 --quiet $BASE $(./ziptiles.py `./extract_corners.sh merge/heli/${IMG}*2.vrt` heli meters) &
	fi
    done
    wait
    echo done heli

elif [[ ${PBS_ARRAYID} -eq 10 ]]; then
    echo start TPC
    for img in `ls ../tpc/*2.vrt`; do
	base=`echo $img|cut -f3 -d/|cut -f1 -d.|sed s/_2//`
	[[ -f final/TPC_${base}.zip ]] && rm final/TPC_${base}.zip
	echo final/TPC_${base}.zip
	## mygroup ${img} tpc
	zip -9 --quiet final/TPC_${base}.zip `mygroup ${img} tpc`
    done
    wait
    echo done topo

fi
## TEMP ## ## ALTERNATIVE TO ADD OVERVIEW TILES ## 
## TEMP ## ## make zipit
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 sec latlon|grep "tiles/..../0/7"`   ## --quiet 
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 tac latlon|grep "tiles/..../1/8"`	  ## --quiet 
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 wac latlon|grep "tiles/..../2/6"`	  ## --quiet 
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ifr latlon|grep "tiles/..../3/7"`	  ## --quiet 
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ifh latlon|grep "tiles/..../4/6"`	  ## --quiet 
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 ifa latlon|grep "tiles/..../5/8"`	  ## --quiet 
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 elev latlon|grep "tiles/..../6/6"`  ## --quiet 
## TEMP ## ## zip -9 final/databases.zip `./ziptiles.py -131.21 50.15 -40.00 23.13 rel latlon|grep "tiles/..../7/6"`	  ## --quiet 
## TEMP ## ## echo done databases
## TEMP ## 
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## ## Now create manifest
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## pushd final
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## rm -f ../tiledatabase.txt
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## for a in *zip; do
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ##     b=`basename $a .zip`;
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ##     #zip -d $a $b
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ##     #../zip.py `basename ${a} .zip` ${CYCLE};
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ##     unzip -l ${a} |grep tiles/${CYCLE}/./8 | cut -f 3- -d/ | cut -f1 -d. |
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## 	while read img; do
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## 	    echo "${b},${img}" >> ../tiledatabase.txt
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## 	done
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## done
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## popd
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## 
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## ## Now create tile lookup database
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## rm -f tiles.db
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## cat << EOF  | sqlite3 tiles.db
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## CREATE TABLE tiles(zip Text,tile Text);
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## .separator ','
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## .import tiledatabase.txt tiles
## TEMP ## ## OBSOLUTE WITH CHART POLYGONS ## EOF
