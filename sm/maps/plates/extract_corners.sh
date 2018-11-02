#!/bin/bash

for tif in $*; do

    if [[ $# -gt 1 ]]; then
	gdalinfo ${tif}| grep Corner -A4 | sed -n '2~1p' > /dev/shm/tmp.txt
	head -n2  /dev/shm/tmp.txt  > /dev/shm/tmp2.txt
	sed -n '4p' /dev/shm/tmp.txt >> /dev/shm/tmp2.txt
	sed -n '3p' /dev/shm/tmp.txt >> /dev/shm/tmp2.txt

	cat /dev/shm/tmp2.txt | cut -f2 -d\(| cut -f1 -d\) | sed s/","/" "/ |
	    while read a b; do
		echo $tif `extract_chart_polygons.py $a $b $imgsize`
	    done
	
    else
	lonmin=`gdalinfo ${tif} |grep "Left"|cut -d\( -f2|cut -d\) -f1 |cut -f1 -d, |sort -n |head -n1`
	lonmax=`gdalinfo ${tif} |grep "Right"|cut -d\( -f2|cut -d\) -f1 |cut -f1 -d, |sort -n |tail -n1`
	latmin=`gdalinfo ${tif} |grep "Left"|cut -d\( -f2|cut -d\) -f1 |cut -f2 -d, |sort -n |head -n1`
	latmax=`gdalinfo ${tif} |grep "Right"|cut -d\( -f2|cut -d\) -f1 |cut -f2 -d, |sort -n |tail -n1`
	## echo $lonmin $latmax $lonmax $latmin
	imgsize=`gdalinfo $tif | grep "Size is"| cut -c 8-|sed s/,//`
	STR=`./extract_chart_polygons.py $lonmin $latmax $lonmax $latmin $imgsize $tif|cut -f2-5 -d\|`
	exiftool -overwrite_original_in_place -q -Comment="$STR" $tif
	PROC=`echo ${tif} |rev|cut -f1-2 -d"/"|rev`
	echo "${PROC}|${STR}"
	## IFS=\| read DUMP DX DY LON LAT <<< `echo $STR`
	## echo $DX $DY $LON $LAT
	## exiftool -overwrite_original_in_place -q -gpslatitude=${LAT} -gpslatituderef=${LAT} -gpslongitude=${LON} -gpslongituderef=${LON} -gpsspeed=${DX} -gpsaltitude=${DY} ${tif}
    fi
done
