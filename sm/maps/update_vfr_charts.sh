#!/bin/bash
# Copyright (c) 2013, Peter A. Gustafson (peter.gustafson@wmich.edu)
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

function update {
    
    UPDATED=
    
    if [[ -d charts/$1 ]]; then
	echo Updating $1
	pushd charts/$1 > /dev/null

	if [[ $1 = wac ]]; then
	    LOC=wac_files;
	elif [[ $1 = sec ]]; then
	    LOC=sectional_files;
	elif [[ $1 = tac ]]; then
	    LOC=tac_files;
	fi


	## for a in *zip; do
	##     unzip -f $a *htm
	## done

	for a in `ls *.zip|grep -vi canyon`; do 

	    [[ `ls *|grep htm$` ]] && rm *htm
	    unzip -q -o $a *htm

	    ## Fix a FAA blunder
	    if [[ `find . -mindepth 2 -type f -name "*htm" |wc -l` -gt 0 ]]; then
		mv `find . -type f -name *htm|awk '{print $1}'`* .
		find . -type d -empty -delete
	    fi

	    ## grep -h -i beginning *htm | head -n1
	    BEGIN=$(grep -h -i beginning *htm | sed "s/[^0-9]//g" |head -n1)
	    BEGIN=$(($(date -u +%s)-$(date -u -d $BEGIN +%s)))
	    let BEGIN/=86400

	    ## grep -h -i ending *htm |head -n1
	    END=$(grep -h -i ending *htm | sed "s/[^0-9]//g" |head -n1)
	    CHARTNAME=`echo $a | rev| cut -c 7- | rev`
	    echo EXPIRATION DATE $CHARTNAME $END | sed s/_//g >> /dev/shm/expired.txt
	    END=$(($(date -u +%s)-$(date -u -d $END +%s)))
	    let END/=-86400

	    echo $a $BEGIN $END | awk '{printf ("%36s has been valid for %3s days and expires in %3s days\n", $1, $2, $3)}'
	       
	    ## Remove the last six characters?
	    BASE=`echo $a | sed 's/.\{6\}$//'`
	    OLD=`echo $a |sed s/$BASE//|cut -f1 -d.`

	    if [[ $BEGIN -lt 10 || $END -lt 28 ]]; then
		CLEAR=`echo $a | sed 's/.\{7\}$//' | sed s/_//g`
		CLEAR=${CLEAR:0:5}
		echo "delete merge/$1/*${CLEAR}*_c.vrt" >> /dev/shm/expired.txt
	    fi

	    if [[ $END -lt 28 ]]; then
		let NEW=$OLD+1
		let EXP=$OLD-1
		echo $BASE $OLD $NEW
	
		wget -c http://aeronav.faa.gov/content/aeronav/${LOC}/${BASE}${NEW}.zip
		if [[ -f ${BASE}${NEW}.zip ]]; then
	    	    UPDATED="${UPDATED} ${BASE}${NEW}.zip"
	    	    echo Removing ${BASE}${OLD}.zip 
	    	    rm ${BASE}${OLD}.zip
		else
		    echo ${BASE}${NEW}.zip not updated and expiring in $END days!!!
		    echo ${BASE}${NEW}.zip not updated and expiring in $END days!!! >> /dev/shm/expired.txt
		fi
	    elif [[ $BEGIN -lt -28 ]]; then
		echo WARNING $a not yet current and downgrading
		let NEW=$OLD-1
		let EXP=$OLD+1
 		echo $BASE $OLD $NEW
 		
 		wget -c http://aeronav.faa.gov/content/aeronav/${LOC}/${BASE}${NEW}.zip
 		if [[ -f ${BASE}${NEW}.zip ]]; then
 	    	    UPDATED="${UPDATED} ${BASE}${NEW}.zip"
 	    	    echo Removing ${BASE}${OLD}.zip 
 	    	    rm ${BASE}${OLD}.zip
 		else
 		    echo ${BASE}${NEW}.zip not available but current!!!
 		    echo ${BASE}${NEW}.zip not available but current!!! >> /dev/shm/expired.txt
 		fi
	    fi

	    rm *htm
	done
# rmtif; unzipclean;
	popd > /dev/null
    else
	echo "update_vfr_charts.sh only works when the old zip files exist."
	echo "If you are starting from scratch, uncomment the chart reapfiles.pl code in the Makefile."
    fi

    [[ $UPDATED ]] && echo Updated charts are `for a in $UPDATED; do echo $a;done` || echo No updates
}

echo > /dev/shm/expired.txt
update wac
update sec
update tac

mv /dev/shm/expired.txt .
