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
    if [[ -d charts/$1 ]]; then
	pushd charts/$1

	if [[ $1 = wac ]]; then
	    LOC=wac_files;
	elif [[ $1 = sec ]]; then
	    LOC=sectional_files;
	elif [[ $1 = tac ]]; then
	    LOC=tac_files;
	fi

	for a in *zip; do 
	    BASE=`echo $a | sed 's/.\{6\}$//'`
	    OLD=`echo $a |sed s/$BASE//|cut -f1 -d.`
	    let NEW=$OLD+1
	    let EXP=$OLD-1
	    echo $BASE $OLD $NEW
	    wget -c http://aeronav.faa.gov/content/aeronav/${LOC}/${BASE}${NEW}.zip
	    if [[ -f ${BASE}${EXP}.zip ]]; then
		echo Removing ${BASE}${EXP}.zip 
		rm ${BASE}${EXP}.zip
	    fi
	done
# rmtif; unzipclean;
	popd
    else
	echo "update_vfr_charts.sh only works when the old zip files exist."
	echo "If you are starting from scratch, uncomment the chart reapfiles.pl code in the Makefile."
    fi
}

update wac
update sec
update tac

