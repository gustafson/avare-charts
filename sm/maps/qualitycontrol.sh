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

CYCLE=`./cyclenumber.sh`
pushd final

for a in *zip; do
    b=`basename $a .zip`; zip -d $a $b #> /dev/null
    echo $b `unzip -l $a |tail -n1` > ${a}.count
    ../zip.py `basename ${a} .zip` ${CYCLE};
done


echo Unzipping reference data
rm -f *ref 
rm -f *qc 
rm -f *manualcheck 

unzip -q ../qualitycontrol.zip
## 
for a in *zip.qc.ref; do
## for a in *zip; do  ## For adding new files to record -- use this and ignore errors
    b=`basename $a .qc.ref`;

    ## Count files and total file size
    if [[ -f $b ]]; then
	unzip -l $b | tail -n1 |awk '{printf "%i\n%i\n", $2, $1}' > ${b}.qc 
	
    ## If it is plates, count airports.  Add one so that you never get divide by zero below.
	unzip -l $b | grep plates | cut -c 31-40 | sort | uniq | wc -l |awk '{printf $1+1}' >> ${b}.qc || echo $b >> missing.txt
	
    ## Now change b
	b=`basename $a .ref`
	
    ## Start with an empty error record
	[[ -f ${b}.manualcheck ]] && rm ${b}.manualcheck 
	
    ## echo Comparing $b $a
    ## Number of files should not change by more than 10%
	paste $b $a |head -n1 | awk '
function abs(x){return ((x < 0.0) ? -x : x)}
{if ((abs($1/$2-1))>0.1) printf "Number of zipped files should not change by more than |10%| but changed from %i to %i which is %0.1f%\n", $2, $1, 100*($1/$2-1)}' >> ${b}.manualcheck
	
	paste $b $a |head -n2 |tail -n1 | awk '
function abs(x){return ((x < 0.0) ? -x : x)}
{if ((abs($1/$2-1))>0.1) printf "Total files size should not change by more than |10%| but changed from %i to %i which is %0.1f%\n", $2, $1, 100*($1/$2-1)}' >> ${b}.manualcheck
	
	if [[ `wc -w $a|cut -c1` -eq 3 ]]; then
	## echo Number of airports should not by more than 2% >> ${b}.manualcheck
	    paste $b $a |tail -n1 | awk '
function abs(x){return ((x < 0.0) ? -x : x)}
{if ((abs($1/$2-1))>=0.02) printf "Number of airports should not change changed by more than |2%| but changed from %i to %i which is %0.1f%\n", $2, $1, 100*($1/$2-1)}' >> ${b}.manualcheck
	fi
	
    ## Erase empty files
	if [[ -s ${b}.manualcheck ]]; then
	    echo
	    echo Inconsistency in ${b} 
	    cat ${b}.manualcheck
	else
	    rm ${b}.manualcheck 
	fi

    else
	echo File $b is missing 
	echo File $b is missing >> ${b}.qc.manualcheck
    fi
done
    

files=$(ls -U *manualcheck 2> /dev/null | wc -l)
if [ "$files" != "0" ]; then
    echo 
    echo "Inconsistency Detected: Manual Check is Recommended."
    echo
    echo "If acceptable, issue the following commands:"
    echo "  pushd final"
    echo "  rename .qc .qc.ref *qc"
    echo "  zip -q -9 qualitycontrol.newref.zip *ref && mv qualitycontrol.newref.zip .."
    echo "  rm *ref *manualcheck"
    echo "  popd"
    echo "  mv qualitycontrol.newref.zip qualitycontrol.zip"
    echo
else
    echo 
    echo "Apparent Success."
    echo
    echo "  Move qualitycontrol.newref.zip to qualitycontrol.zip to update the result."
    echo "  Here is a command:"
    echo "     mv qualitycontrol.newref.zip qualitycontrol.zip"
    echo
    rename .qc .qc.ref *qc
    rm *count
    zip -q -9 qualitycontrol.newref.zip *ref && mv qualitycontrol.newref.zip ..
    rm *ref
fi

popd
