#!/bin/bash
#SBATCH --mem-per-cpu=2000
#SBATCH --ntasks=20
#SBATCH --time=1000:00:00
#SBATCH --job-name=AFD
#SBATCH --array=0-3
#SBATCH --output=z-logs/AFD_%A_%a.out
#SBATCH --error=z-logs/AFD_%A_%a.err

# Copyright (c) 2012-2014, Apps4av Inc. (apps4av@gmail.com) 
# Copyright (c) 2014-2024, Peter A. Gustafson
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


[[ -d ${SLURM_SUBMIT_DIR}/afd ]] || mkdir -p ${SLURM_SUBMIT_DIR}/afd
[[ -d ${SLURM_SUBMIT_DIR}/final ]] || mkdir -p ${SLURM_SUBMIT_DIR}/final
[[ -d ${SLURM_SUBMIT_DIR}/final_webp ]] || mkdir -p ${SLURM_SUBMIT_DIR}/final_webp

CYCLE=`./cycledates.sh 56`
CYCLEDATE=`./cycledates.sh 56 afd`
CYCLENUMBER=`./cyclenumber.py`

pushd ${SLURM_SUBMIT_DIR}/afd

## Download only if not already downloaded, and not unzip.  This will be measured by how many pdfs are there:
if [[ `ls *pdf|wc -l` -eq 0 ]]; then
    [[ -f DCS_${CYCLEDATE}.zip ]] || wget -c http://aeronav.faa.gov/upload_313-d/supplements/DCS_${CYCLEDATE}.zip
    unzip -o DCS_${CYCLEDATE}.zip

    ## Deal with case
    for a in SE NE NC NW SC SW EC AK PAC; do
	rename ${a} ${a,,} ${a}*pdf
    done

    ## Remove the cycle name
    rename _${CYCLE} "" *pdf
    rm *front*pdf *rear*pdf
fi

## Do the work
nice ${SLURM_SUBMIT_DIR}/afd.py --cpus ${SLURM_NTASKS} --nnodes 4 --node ${SLURM_ARRAY_TASK_ID} > /dev/shm/afd.csv.${SLURM_ARRAY_TASK_ID}

sort /dev/shm/afd.csv.${SLURM_ARRAY_TASK_ID} >> ${SLURM_SUBMIT_DIR}/afd.csv
rm /dev/shm/afd.csv.${SLURM_ARRAY_TASK_ID}
popd
