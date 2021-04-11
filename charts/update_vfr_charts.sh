#!/bin/bash
# Copyright (c) 2013-2019 Peter A. Gustafson (peter.gustafson@wmich.edu)
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

CYCLE=$(./cyclenumber.py)
VFRFILE=$(./cycledates.sh 56 ifr)
echo ${VFRFILE}
function rmtif {
    rm *tif
}

function unzipclean {
    for a in *zip; do 
	unzip $a;
    done
    rm *htm
    rm *tfw
}


TMP=charts/vfr-downloads

##
echo removing old zips
## rm -f ${TMP}/*zip ${TMP}/*tif

echo Fetching VFR update for $CYCLE
[[ -d $TMP ]] || mkdir $TMP

pushd $TMP

rm -f *tif
echo $VFRFILE
wget -c https://aeronav.faa.gov/visual/${VFRFILE}/All_Files/Sectional.zip
wget -c https://aeronav.faa.gov/visual/${VFRFILE}/All_Files/Terminal.zip
wget -c https://aeronav.faa.gov/visual/${VFRFILE}/All_Files/Helicopter.zip
wget -c https://aeronav.faa.gov/visual/${VFRFILE}/All_Files/Grand_Canyon.zip
wget -c https://aeronav.faa.gov/visual/${VFRFILE}/All_Files/Caribbean.zip

for VFRFILE in *zip; do

    echo STARTING ${VFRFILE}
     ## Unzip tiff files
     if [[ -f ${VFRFILE} ]]; then
 	unzip ${VFRFILE} "*tif"
     fi
done

echo Renaming files
for a in `seq 10`; do
    rename " " "" *
done
rename \' "" Chicago*

echo Fixing filenames for Caribbean charts
rename VFRChart SEC Caribbean[12]*tif

for type in TAC SEC HEL FLY; do
    echo Working on $type
    
    TYPE=${type,,}

    ## Work on any remaining files of the type
    if [[ `ls *${type}*tif 2> /dev/null |wc -l` -gt 0 ]]; then
	for file in *${type}*tif; do
	    
	    echo working on $file
	    mv $file ../${TYPE}/.
	done
    fi
done

mv ./charts/vfr-downloads/GrandCanyonGeneralAviation.tif ./charts/hel/GrandCanyonGeneralAviation.tif
mv ./charts/sec/HonoluluInsetSEC.tif ./charts/tac/HonoluluInsetSEC.tif
