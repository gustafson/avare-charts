#!/bin/bash
STEP=$1
CYCLE=$2


## A function to extract the database information
## Parallelizable extraction
function extract_db() {
    ARG=$0
    SIZE=$1
    if [[ $SIZE=1860 ]]; then
	SCALE=1.5
    elif [[ $SIZE=2480 ]]; then
	SCALE=2.0
    else
	SCALE=1.0 #1240 1860 2480
    fi
	
    if [[ `gdalinfo ${ARG} 2> /dev/null | grep -i PROJCS` ]]; then
	## Write gdal geotag information into the file
	echo TAGGING ${ARG}
	./extract_corners.sh ${ARG}
	
    else
	## If gdal geocode isn't available, write an old one from when manual tagging was done
	PROC=`echo ${ARG} | cut -f2 -d_ | cut -c 4-`
	
	sqlite3 geoplates.db "select dx, dy, lon, lat from geoplates where proc like '$PROC'" |
	    head -n1 | ## Superfically, we need the first one.  Testing this theory.
	    awk -v SCALE="$SCALE" -F"|" '{printf ("%f|%f|%g|%g\n", $1*SCALE, $2*SCALE, $3, $4)}' |
	    while read STR; do
		# exiftool -overwrite_original_in_place -q -Comment="$STR" ${ARG}
		mogrify -set comment "$STR" ${ARG}
		echo "${PROC}|${STR}"|grep -v AIRPORT
	    done

	    ## while IFS=\| read dx dy lon lat; do
	    ## 	## Note old plate size was 807x1238, new size without in-built tagging is based on 225 dpi
	    ## 	identify -format "%[fx:w]|%[fx:h]\n" ${ARG} |
	    ## 	    while IFS=\| read w h; do
	    ## 		dx=`echo ${w}/807*${dx}|bc -l`
	    ## 		dy=`echo ${h}/1238*${dy}|bc -l`
	    ## 		## STR=`printf "%0.5f|%0.5f|%g|%g" $dx $dy $lon $lat`
	    ## 		## Minimize any rounding errors as we don't know how long this might go on
	    ## 		STR="$dx|$dy|$lon|$lat"
	    ## 		exiftool -overwrite_original_in_place -q -Comment="$STR" ${ARG}
	    ## 		echo "${PROC}|${STR}"|grep -v AIRPORT
	    ## 	    done
	    ## done
    fi
}
export -f extract_db


## Variable which defines a single size that is applied.  Otherwise,
## several sizes may be tried at the same run
SINGLESIZE=1860
## SINGLESIZE=1240

## $STEP is a variable which allows python to call different system commands.
if [[ $STEP -eq 0 ]]; then
    ## move files around, create and optimize raster images
    
    STATE=$3
    PLATE=$4
    DIR=`dirname ${PLATE}`
    BASE=`basename ${PLATE} .pdf`
    AIRPORT=`echo ${DIR} | rev|cut -f1 -d/|rev`

    ## ## For debugging a single airport
    ## if [[ ! ${AIRPORT} == AZO ]]; then
    ## 	exit
    ## else
    ## 	echo Doing single airport ${AIRPORT}
    ## fi

    FN=$DIR/$BASE
    if [[ -f ${FN}.pdf ]]; then
	for SIZE in ${SINGLESIZE}; do # 1240 1860 2480
    	    [[ -d plates.archive/${CYCLE}/plates_${STATE}/${AIRPORT} ]] || mkdir -p plates.archive/${CYCLE}/plates_${STATE}/${AIRPORT}

    	    if [[ `gdalinfo ${FN}.pdf 2> /dev/null | grep -i PROJCS` ]]; then ##
	    ## if [[ $NO ]]; then
    		gdalwarp -q -dstalpha -r lanczos -t_srs 'EPSG:3857' -ts 0 ${SIZE} ${FN}.pdf -of VRT ${FN}_${SIZE}_1.vrt 
    		gdal_translate -q -r lanczos ${FN}_${SIZE}_1.vrt -of PNG  ${FN}_${SIZE}.256.png
		mogrify -background white -alpha remove ${FN}_${SIZE}.256.png
		rm ${FN}_${SIZE}.256.png.aux.xml
		SRCWIN=`convert ${FN}_${SIZE}.256.png -trim -format "%X %Y %w %h" info:`
		gdal_translate -q -r lanczos ${FN}_${SIZE}_1.vrt -srcwin ${SRCWIN} -of PNG  ${FN}_${SIZE}.256.png

		mogrify -dither none -antialias  -depth 8 -quality 00 -background white -alpha remove -colors 15 -format png8 ${FN}_${SIZE}.256.png # -unsharp 0x0
		mv ${FN}_${SIZE}.256.png8 ${FN}_${SIZE}.16.png

		## Webp using either gdal (to get the xml file) and imagemagick
		gdal_translate -q -r lanczos ${FN}_${SIZE}_1.vrt -srcwin ${SRCWIN} -co LOSSLESS=True -of WEBP ${FN}_${SIZE}.webp
		convert -format webp -define webp:lossless=true,method=6 ${FN}_${SIZE}.16.png ${FN}_${SIZE}.webp
		
		## mogrify -dither none -antialias  -depth 8 -quality 00 -background white -alpha remove ${FN}_${SIZE}.256.png # -unsharp 0x0
    		mv ${FN}_${SIZE}.256.png.aux.xml ${FN}_${SIZE}.png.aux.xml
    		optipng -quiet ${FN}_${SIZE}.*.png

		## Use 16 color only for now
		mv ${FN}_${SIZE}.16.png ${FN}_${SIZE}.png
		rm -f ${FN}_${SIZE}.256.png ${FN}_${SIZE}.256.vrt 
		
		## Store the files
		mv ${FN}_${SIZE}.png ${FN}_${SIZE}.png.aux.xml plates.archive/${CYCLE}/plates_${STATE}/${AIRPORT}/.
    		## Already hardlinked there ## mv ${FN}.pdf plates.archive/${CYCLE}/plates_${STATE}/${AIRPORT}/.
		mv ${FN}_${SIZE}.webp ${FN}_${SIZE}.webp.aux.xml plates.archive/${CYCLE}/plates_${STATE}/${AIRPORT}/.
		
    	    else
		## NO GDAL info available
		## PAGES=`pdfinfo  HOT-SPOT.pdf |grep -i pages|awk '{print $2}'`

		if [[ ${SIZE} -eq 1240 ]]; then
		    DENS=150
		elif [[ ${SIZE} -eq 1860 ]]; then
		    DENS=225
		elif [[ ${SIZE} -eq 2480 ]]; then
		    DENS=300
		fi

		DENS=150
		TRIM="-trim +repage"
		## UPDATE No trimming at all while using old geotags
		## TRIM=""
		
		#echo ${FN}.pdf
		if [[ `basename ${FN}.pdf` == AIRPORT-DIAGRAM.pdf ]]; then
		    ## Until airport diagram database is updated:
		    DENS=150
		    ## Do not trim airport diagrams until
		    TRIM=""
		fi

		## Convert and optimize
		convert -density ${DENS} -dither none -antialias -depth 8 -quality 00 -background white -alpha remove ${TRIM} -colors 15 ${FN}.pdf -format png8 ${FN}_${SIZE}.png
    		optipng -quiet ${FN}_${SIZE}*.png

		## Store the files
		mv ${FN}_${SIZE}*.png plates.archive/${CYCLE}/plates_${STATE}/${AIRPORT}/.
    		mv ${FN}.pdf plates.archive/${CYCLE}/plates_${STATE}/${AIRPORT}/.
    		
    	    fi
    	    rm -f ${FN}_${SIZE}.*.{webp,png} ${FN}_${SIZE}_1.vrt 
	done

	rm -f ${FN}.pdf
	[[ -d /dev/shm/plates/${AIRPORT} ]] && rmdir --ignore-fail-on-non-empty /dev/shm/plates/${AIRPORT}
	[[ -d /dev/shm/plates ]] && rmdir --ignore-fail-on-non-empty /dev/shm/plates
    fi

elif [[ $STEP -eq 1 ]]; then
    for STATE in plates.archive/${CYCLE}/*; do
	if [[ ${SINGLESIZE} ]]; then
	    rename _${SINGLESIZE} "" ${STATE}/*/*_${SINGLESIZE}*
	fi
    done
    
    rm -f updated_db_vals_*.txt
    ## Do the extraction for each state
    for STATE in plates.archive/${CYCLE}/*; do
	for FORMAT in png webp; do
	    if [[ ${SINGLESIZE} ]]; then
		find ${STATE} -name "*.${FORMAT}" 
		find ${STATE} -name "*.${FORMAT}" | xargs -n 1 -P 16 bash -c 'extract_db "$@ $SINGLESIZE"' | tee -a updated_db_vals_${SINGLESIZE}.txt
	    else
		for SIZE in 1240 1860 2480; do
		    find ${STATE} -name "*${SIZE}*.${FORMAT}" | xargs -n 1 -P 16 bash -c 'extract_db "$@ $SIZE""' | tee -a updated_db_vals_${SIZE}.txt
		done
	    fi
	done
    done
    if [[ ${SINGLESIZE} ]]; then
	sqlite3 geoplates.db "select proc,dx,dy,lon,lat from geoplates where proc like '%area%';" >> updated_db_vals_${SINGLESIZE}.txt
    else
	for SIZE in 1240 1860 2480; do
	    sqlite3 geoplates.db "select proc,dx,dy,lon,lat from geoplates where proc like '%area%';" >> updated_db_vals_${SIZE}.txt
	done
    fi
    
elif [[ $STEP -eq 2 ]]; then
    ## Create zip files
    for STATE in plates.archive/${CYCLE}/*; do
	rsync -avPq ${STATE}/ /dev/shm/plates/
	STATE=${STATE: -2}_PLATES

	for FORMAT in png webp; do 
	    pushd /dev/shm/
	    if [[ ${SINGLESIZE} ]]; then
		echo $CYCLE > ${STATE}
		find plates -name "*.${FORMAT}" >> ${STATE}
		zip -9 ${STATE}.zip ${STATE} `find plates -name "*.${FORMAT}"`
	    else
		for SIZE in 1240 1860 2480; do
		    echo $CYCLE > ${STATE}
		    find plates -name "*${SIZE}.${FORMAT}" >> ${STATE}
     		    zip -9 ${STATE}_${SIZE}.zip ${STATE} `find plates -name "*${SIZE}.${FORMAT}"`
		done
	    fi
	    popd ## Move back into the original directory
	    [[ -d final_${FORMAT} ]] || mkdir final_${FORMAT}
	    mv /dev/shm/${STATE}*.zip final_${FORMAT}/.
	done
	pushd /dev/shm/
	rm -fr plates ${STATE}
	popd
    done
fi
