#!/bin/bash

if [[ $# -lt 1 ]]; then 
    echo Cycle number argument required; 
    exit
fi

[[ -d tiles/$1 ]] && rm -fr tiles/$1

## Do TAC separately since it takes the longest by a substantial margin
J0=`qsub stagetac.pbs -v CYCLE=$1`
J0=`qsub -W depend=afterok:${J0} pyramids-tac.pbs -v CYCLE=$1`

## Do the rest
J1=`qsub stagesec.pbs -v CYCLE=$1`
J2=`qsub stageifr.pbs -v CYCLE=$1`
J3=`qsub stageifh.pbs -v CYCLE=$1`
J4=`qsub stageifal.pbs -v CYCLE=$1`
J5=`qsub stageifah.pbs -v CYCLE=$1`
J6=`qsub -W depend=afterok:${J1}:${J2}:${J3}:${J4}:${J5} pyramids.pbs -v CYCLE=$1`
J7=`qsub -W depend=afterok:${J0}:${J6} databases.pbs -v CYCLE=$1`
