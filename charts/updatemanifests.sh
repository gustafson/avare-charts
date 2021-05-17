#!/bin/bash

CYCLE=`./cyclenumber.py`

## Only these require manifest updates (Includes IFR older than the
## last cycle conclusion) ## C?-[0-9]*zip for a in ENRA_* ELUS_*
## EHUS_* C?-*zip Area*zip AFD_*zip alternates.zip; do #

pushd final
DIR=`pwd`

for a in `ls *zip`; do # | grep -v -e PLATE  -e ELUS -e EHUS |grep AFD
    ## echo Updating $a
    b=`basename $a .zip`;
    cd /dev/shm
    rm -f $b
    unzip $DIR/$a $b > /dev/null
    if [[ `grep $CYCLE $b` ]]; then
	RESULT=leave;
    else
	RESULT=replace
    fi
    rm -f $b
    cd $DIR
    if [[ $RESULT == replace ]]; then
	zip -d $a $b #> /dev/null
	../zip.py `basename ${a} .zip` ${CYCLE};
    fi
done

popd
