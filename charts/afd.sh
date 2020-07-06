#!/bin/bash
#SBATCH --mem-per-cpu=2000
#SBATCH --ntasks=8
#SBATCH --time=1000:00:00
#SBATCH --job-name=AFD
#SBATCH --output=z-logs/AFD_%A_%a.out
#SBATCH --error=z-logs/AFD_%A_%a.out

# Copyright (c) 2012-2014, Apps4av Inc. (apps4av@gmail.com) 
# Copyright (c) 2014-2020, Peter A. Gustafson
# Author: Zubair Khan (governer@gmail.com)
# Author: Peter A. Gustafson (peter.gustafson@wmich.edu)
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

if [[ ${SLURM_NTASKS} ]]; then
    NP=${SLURM_NTASKS}
else
    NP=`cat /proc/cpuinfo |grep processor|wc -l`
fi

echo "SLURM_JOBID: $SLURM_JOBID"
echo "SLURM_JOB_NODELIST: $SLURM_JOB_NODELIST"
echo "SLURM_NNODES: $SLURM_NNODES"
echo "SLURM_NTASKS: $SLURM_NTASKS"
echo "SLURMTMPDIR: $SLURMTMPDIR"
echo "working directory = $SLURM_SUBMIT_DIR"

if [[ ${SLURM_SUBMIT_DIR} ]]; then
    cd ${SLURM_SUBMIT_DIR}
else
    SLURM_SUBMIT_DIR=`pwd`
fi

CYCLE=`./cycledates.sh 56`
CYCLEDATE=`./cycledates.sh 56 afd`
CYCLENUMBER=`./cyclenumber.sh`

[[ -d /dev/shm/afd ]] && rm -fr /dev/shm/afd
mkdir -p /dev/shm/afd/afd

pushd /dev/shm/afd/afd
wget -c http://aeronav.faa.gov/upload_313-d/supplements/DCS_${CYCLEDATE}.zip
unzip -o DCS_${CYCLEDATE}.zip

## Format change 2008 cycle
[[ -d DCS_${CYCLEDATE} ]] && mv DCS_${CYCLEDATE}/*pdf DCS_${CYCLEDATE}/*xml .

for a in SE NE NC NW SC SW EC AK PAC; do
    rename ${a} ${a,,} ${a}*pdf
done
rename _${CYCLE} "" *pdf
rm *front*pdf *rear*pdf

## deal with september typo
rename seP SEP *pdf

popd
pushd /dev/shm/afd

perl ${SLURM_SUBMIT_DIR}/afd.pl ${CYCLE} afd/*xml
cp afd.csv ${SLURM_SUBMIT_DIR}/.

## Divide and conquer
NPDF=`ls afd/*.pdf|wc -l`
NPDFPER=$((NPDF/NP+1))
echo $NPDF pdf files at $NPDFPER per task with $NP tasks

## DPI=240.9  #Android limited plates size 2400x
DPI=225

## ## Convert to png
find afd -name "*.pdf" | 
xargs -P ${NP} -n ${NPDFPER} mogrify -trim +repage -dither none -antialias -density ${DPI} -depth 8 -quality 00 -background white  -alpha remove -alpha off -colors 15 -format png
wait

## Optimize the png for file size and rendering
find afd -name "*.png" | 
xargs -P ${NP} -n ${NPDFPER} optipng -quiet
wait

find afd -name "*.pdf" | 
xargs -P ${NP} -n ${NPDFPER} mogrify -trim +repage -dither none -antialias -density ${DPI} -depth 8 -quality 00 -background white  -alpha remove -alpha off -colors 15 -format webp -define webp:lossless=true,method=6
wait

## Zip the files
for file in NE NC NW SE SC SW EC AK PAC; do
    rm -f ${SLURM_SUBMIT_DIR}/final/AFD_${file}.zip
    echo $CYCLENUMBER > AFD_${file}
    ls afd/*${file,,}*.png >> AFD_${file};
    zip -9 ${SLURM_SUBMIT_DIR}/final/AFD_${file}.zip afd/*${file,,}*.png AFD_${file}

    rm -f ${SLURM_SUBMIT_DIR}/final_webp/AFD_${file}.zip
    echo $CYCLENUMBER > AFD_${file}
    ls afd/*${file,,}*.webp >> AFD_${file};
    zip -9 ${SLURM_SUBMIT_DIR}/final_webp/AFD_${file}.zip afd/*${file,,}*.webp AFD_${file}
done

popd
rm -rf /dev/shm/afd
