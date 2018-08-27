echo EPSG:900913 is formally EPS:3857 but a bug means it is using EPSG:3395 hence we use EPS:3857 instead
EPSG=EPSG:3857

cat <<EOF > east.csv
Nr;WKT
1;POLYGON ((0.0000000001 85, 179.9999999999 85, 179.9999999999 -85, 0.0000000001 -85, 0.0000000001 85))
EOF

cat <<EOF > west.csv
Nr;WKT
1;POLYGON ((-179.9999999999 85, 359.9999999999 85, 359.9999999999 -85, -179.9999999999 -85, -179.9999999999 85))
EOF

ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -segmentize 2500 east.shp east.csv
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -segmentize 2500 west.shp west.csv

rm {east,west}.csv

for TYPE in ifr; do # ifr
    filew=${TYPE}-west.shp
    filee=${TYPE}-east.shp

    rm -f $filew $filee

    for FILE in `ls merge/${TYPE}/*_1.vrt`; do
	
    	## start from scratch creating a bounding box
    	rm -f ${FILE}cropbox.shp ${FILE}.shp ${FILE}west.geojson ${FILE}west.shp ${FILE}east.geojson ${FILE}east.shp
    	gdaltindex ${FILE}cropbox.shp ${FILE}  ## could do conversion here... but segmenting later is desirable (-t_srs EPSG:4326)
    	
    	## Project into a lat lon based system
    	ogr2ogr -segmentize 2500 -t_srs EPSG:4326 shifted0.shp ${FILE}cropbox.shp
    	ogr2ogr -t_srs ${EPSG} shifted03857.shp shifted0.shp
    	## ogr2ogr ${FILE}cropbox.csv shifted03857.shp -dialect sqlite -sql "select MbrMinY(Geometry),MbrMaxY(Geometry) from shifted03857";
    	## ogr2ogr shifted0.csv shifted0.shp -dialect sqlite -sql "select MbrMinY(Geometry),MbrMaxY(Geometry) from shifted0";
    	
    	## Shift its lon and that of the western hemisphere (now going from 0 to 360)
    	ogr2ogr shifted1.shp shifted0.shp -dialect sqlite -sql "select ST_Shift_Longitude(Geometry) from shifted0";
    	ogr2ogr shiftedwest.shp west.shp -dialect sqlite -sql "select ST_Shift_Longitude(Geometry) from west";
    	
    	## Now clip the shape file to hemispheres
    	ogr2ogr -clipsrc shiftedwest.shp shifted2w.shp shifted1.shp; ## shiftedwest.shp 
    	ogr2ogr -clipsrc east.shp shifted2e.shp shifted1.shp; ## shiftedwest.shp 
	
    	## Shift back and warp
    	ogr2ogr shifted3w.shp shifted2w.shp -dialect sqlite -sql "select ShiftCoords(Geometry,-360,0) from shifted2w"; 2> /dev/null && ## This one might fail
    	    ogr2ogr -t_srs ${EPSG} ${FILE}west.shp shifted3w.shp 2> /dev/null &&
    	    ogr2ogr shifted0w.shp ${FILE}west.shp &&
    	    ogr2ogr ${FILE}west.csv shifted0w.shp -dialect sqlite -sql "select MbrMinY(Geometry),MbrMaxY(Geometry) from shifted0w";
    	
    	ogr2ogr shifted3e.shp shifted2e.shp -dialect sqlite -sql "select ShiftCoords(Geometry,   0,0) from shifted2e"; 2> /dev/null && ## This one might fail
    	    ogr2ogr -t_srs ${EPSG} ${FILE}east.shp shifted3e.shp 2> /dev/null &&
    	    ogr2ogr shifted0e.shp ${FILE}east.shp &&
    	    ogr2ogr ${FILE}east.csv shifted0e.shp -dialect sqlite -sql "select MbrMinY(Geometry),MbrMaxY(Geometry) from shifted0e";
	
    	rm shifted*{shp,shx,prj}
    	if [[ -f $filew ]]; then
    	    if [[ -f ${FILE}west.shp ]]; then
    		echo merging $filew
    		ogr2ogr -update -append $filew ${FILE}west.shp
    	    fi
    	    if [[ -f ${FILE}east.shp ]]; then
    		echo merging $filee
    		ogr2ogr -update -append $filee ${FILE}east.shp
    	    fi
    	else
    	    echo creating
    	    if [[ -f ${FILE}west.shp ]]; then
    		ogr2ogr $filew ${FILE}west.shp
    	    fi
    	    if [[ -f ${FILE}east.shp ]]; then
    		ogr2ogr $filee ${FILE}east.shp
    	    fi
    	fi
    done

    ## Create geojson which is txt
    ## rm -f *geojson
    ## ogr2ogr `basename $filew .shp`.geojson $filew
    ## ogr2ogr `basename $filee .shp`.geojson $filee

    ## Base level 0 is two tiles (one per hemisphere). Compute the estimated required resolution.
    if [[ ${TYPE} = ifh ]]; then
    	TR=`echo |awk '{print (20026376.39)/512/(2**9);}'`
    	END=pdf
    else
    	TR=`echo |awk '{print (20026376.39)/512/(2**10);}'`
    	END=tif
    fi
    
    for a in `ls merge/${TYPE}/*{west,east}.shp|xargs -n1 -I % basename %`; do
    	b=`basename $a|cut -c 3-|cut -f1-2 -d_`
	
    	## Could do a lower sample resolution but it doesn't seem to benefit much
    	## if [[ $b =~ .*P01.* ]]; then  ## [[ $b =~ .*AKH02.* || $b =~ .*P01.* ]]; then
    	## 	TRR=`echo |awk -v TR=$TR '{print TR*2;}'`
    	## else
    	## 	TRR=$TR
    	## fi
    	
    	TRR=$TR
    	
    	echo "merge/${TYPE}/${a}.tif.time gdalwarp -multi -wm 512 -r bilinear -cutline merge/${TYPE}/$a -crop_to_cutline -dstnodata 51 -tr $TRR $TRR -t_srs ${EPSG} charts/ifr/$b.pdf merge/${TYPE}/${a}.tif -of gtiff -overwrite" 
    done |xargs -L1 -P8 /usr/bin/time -v -o echo 
    
    rm -f merge/${TYPE}/${TYPE}-west.vrt; gdalbuildvrt merge/${TYPE}/${TYPE}-west.vrt merge/${TYPE}/*west*shp*tif
    rm -f merge/${TYPE}/${TYPE}-east.vrt; gdalbuildvrt merge/${TYPE}/${TYPE}-east.vrt merge/${TYPE}/*east*shp*tif
    
    rm -f ${TYPE}-east.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin  123.5 62.0 180.0 -5.25 -a_nodata 51 -of vrt merge/${TYPE}/${TYPE}-east.vrt ${TYPE}-east.vrt
    rm -f ${TYPE}-west.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72.2 -62.7 -5.25 -a_nodata 51 -of vrt merge/${TYPE}/${TYPE}-west.vrt ${TYPE}-west.vrt

done

# qsub -t3,4 generate-tiles.pbs
