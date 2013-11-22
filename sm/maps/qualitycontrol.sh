#!/bin/bash

# Copyright (c) 2013, Peter Gustafson (peter.gustafson@wmich.edu)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
# * notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
# * notice, this list of conditions and the following disclaimer in
# * the documentation and/or other materials provided with the
# * distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

pushd final

echo Unzipping reference data
unzip -q ../qualitycontrol.zip

for a in *.zip; do
    ## Count files and total file size
    unzip -l $a | tail -n1 |awk '{printf "%i\n%i\n", $2, $1}' > ${a}.qc

    ## If it is plates, count airports.  Add one so that you never get divide by zero below.
    unzip -l $a | grep plates | cut -c 31-40 | sort | uniq | wc -l |awk '{printf $1+1}' >> ${a}.qc
done


for a in *.ref; do
    b=`basename $a .ref`
    echo Comparing $b $a

    ## Number of files should not change by more than 10%
    paste $b $a |head -n2 | awk '
function abs(x){return ((x < 0.0) ? -x : x)}
{if ((abs(1-$1/$2))>0.1) printf "%f\n", (abs(1-$1/$2))}' >> ${b}.manualcheck
    
    if [[ `wc -w $a|cut -c1` -eq 3 ]]; then
	## Number of airports should not change
	paste $b $a |tail -n1 | awk '
function abs(x){return ((x < 0.0) ? -x : x)}
{if ((abs(1-$1/$2))!=0) printf "%f\n", (abs(1-$1/$2))}' >> ${b}.manualcheck
    fi

    ## Erase empty files
    [[ -s ${b}.manualcheck ]] || rm ${b}.manualcheck
done
    

files=$(ls -U *manualcheck 2> /dev/null | wc -l)
if [ "$files" != "0" ]; then
    echo 
    echo "Inconsistency Detected: Manual Check is Recommended."
    echo
else
    echo 
    echo "Apparent Success."
    echo "  Move qualitycontrol.newref.zip to qualitycontrol.zip to update the result."
    echo "  Here is a command:"
    echo "     mv qualitycontrol.newref.zip qualitycontrol.zip"
    echo
    zip -q -9 qualitycontrol.newref.zip *ref && mv qualitycontrol.newref.zip ..
    rm *ref
    rm *qc
fi

popd
