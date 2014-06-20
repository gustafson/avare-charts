#!/bin/bash

if [[ $# -lt 1 ]]; then 
    echo Cycle number argument required; 
    exit
fi

[[ -d tiles/$1/tac ]] && rm -fr tiles/$1/tac
J0=`qsub -N tac-stage stagetac.pbs -v CYCLE=$1,TILES=tac`
J1=`qsub -N tac-pyram -W depend=afterok:${J0} retile.pbs           -v CYCLE=$1,TILES=tac`
J1=`qsub -N tac-db    -W depend=afterokarray:${J1} retile_databases.pbs -v CYCLE=$1,TILES=tac`

[[ -d tiles/$1/sec ]] && rm -fr tiles/$1/sec
[[ -d tiles/$1/wac ]] && rm -fr tiles/$1/wac
J0=`qsub -N sec-stage stagesec.pbs -v CYCLE=$1,TILES=sec`
J1=`qsub -N sec-pyram -W depend=afterok:${J0} retile.pbs -v CYCLE=$1,TILES=sec`
J2=`qsub -N wac-pyram -W depend=afterok:${J0} retile.pbs -v CYCLE=$1,TILES=wac`
J2=`qsub -N wac-db    -W depend=afterokarray:${J1}:${J2} retile_databases.pbs -v CYCLE=$1,TILES=wac`

[[ -d tiles/$1/ifr ]] && rm -fr tiles/$1/ifr
J0=`qsub -N ifr-stage  stageifr.pbs  -v CYCLE=$1,TILES=ifr`
J1=`qsub -N ifal-stage stageifal.pbs -v CYCLE=$1,TILES=ifal`
J2=`qsub -N ifr-pyram -W depend=afterok:${J0}:${J1} retile.pbs -v CYCLE=$1,TILES=ifr`
J2=`qsub -N ifr-db    -W depend=afterokarray:${J2}       retile_databases.pbs -v CYCLE=$1,TILES=ifr`

[[ -d tiles/$1/ifh ]] && rm -fr tiles/$1/ifh
J0=`qsub -N ifh-stage  stageifh.pbs  -v CYCLE=$1,TILES=ifh`
J1=`qsub -N ifah-stage stageifah.pbs -v CYCLE=$1,TILES=ifah`
J2=`qsub -N ifh-pyram -W depend=afterok:${J0}:${J1} retile.pbs -v CYCLE=$1,TILES=ifh`
J2=`qsub -N ifh-db    -W depend=afterokarray:${J2}       retile_databases.pbs -v CYCLE=$1,TILES=ifh`


## The following are done only when needed

## J0=`qsub -N oth-pyram retile.pbs -v CYCLE=$1,TILES=oth -l nodes=1:ppn=11`
## J0=`qsub -N heli-stage stageheli.pbs  -v CYCLE=$1,TILES=oth`
