#!/bin/bash

pushd final

echo Unzipping reference data
unzip -q ../qualitycontrols.zip

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
else
    echo 
    echo "Apparent Success."
    zip -q -9 qualitycontrols.newref.zip *ref && mv qualitycontrols.newref.zip ..
    rm *ref
    rm *qc
fi

popd
