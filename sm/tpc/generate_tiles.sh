for a in *tif; do
    b=`basename $a .tif`;
    gdal_translate -of vrt -a_nodata '0 0 0' -expand rgb ${b}.tif ${b}_1.vrt
    gdalwarp -of vrt -t_srs 'EPSG:900913' ${b}_1.vrt ${b}_2.vrt;
done 

gdalbuildvrt -resolution highest -overwrite tpc.vrt *_2.vrt
