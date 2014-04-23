#!/bin/bash

if [[ $# -lt 1 ]]; then 
    echo Cycle number argument required; 
    exit
fi

[[ -d tiles/$1 ]] && rm -fr tiles/$1

J0=`qsub -N tac-stage stagetac.pbs -v CYCLE=$1,TILES=tac`
J0=`qsub -N tac-pyram -W depend=afterok:${J0} pyramids.pbs -v CYCLE=$1,TILES=tac -l nodes=1:ppn=5`
J0=`qsub -N tac-datab -W depend=afterok:${J0} databases.pbs -v CYCLE=$1,TILES=tac`

J0=`qsub -N sec-stage stagesec.pbs -v CYCLE=$1,TILES=sec`
J1=`qsub -N sec-pyram -W depend=afterok:${J0} pyramids.pbs -v CYCLE=$1,TILES=sec -l nodes=1:ppn=3`
J1=`qsub -N sec-datab -W depend=afterok:${J1} databases.pbs -v CYCLE=$1,TILES=sec`

J0=`qsub -N wac-pyram -W depend=afterok:${J0} pyramids.pbs -v CYCLE=$1,TILES=wac -l nodes=1:ppn=2`
J0=`qsub -N wac-datab -W depend=afterok:${J0} databases.pbs -v CYCLE=$1,TILES=wac`

J0=`qsub -N ifr-stage  stageifr.pbs  -v CYCLE=$1,TILES=ifr`
J1=`qsub -N ifal-stage stageifal.pbs -v CYCLE=$1,TILES=ifal`
J0=`qsub -N ifr-pyram -W depend=afterok:${J0}:${J1} pyramids.pbs -v CYCLE=$1,TILES=ifr`
J0=`qsub -N ifr-datab -W depend=afterok:${J0} databases.pbs -v CYCLE=$1,TILES=ifr`

J0=`qsub -N ifh-stage  stageifh.pbs  -v CYCLE=$1,TILES=ifh`
J1=`qsub -N ifah-stage stageifah.pbs -v CYCLE=$1,TILES=ifah`
J0=`qsub -N ifh-pyram -W depend=afterok:${J0}:${J1} pyramids.pbs -v CYCLE=$1,TILES=ifh`
J0=`qsub -N ifh-datab -W depend=afterok:${J0} databases.pbs -v CYCLE=$1,TILES=ifh`

## J0=`qsub -N heli-stage  stageheli.pbs  -v CYCLE=$1,TILES=oth`
## J0=`qsub -N oth-pyram -W depend=afterok:${J0} pyramids.pbs -v CYCLE=$1,TILES=oth -l nodes=1:ppn=11`
J0=`qsub -N oth-pyram pyramids.pbs -v CYCLE=$1,TILES=oth -l nodes=1:ppn=11`
J0=`qsub -N oth-datab -W depend=afterok:${J0} databases.pbs -v CYCLE=$1,TILES=oth`
