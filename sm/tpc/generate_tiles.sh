OPTIONS1="-w openlayers -c MUAVLLC --no-kml --resume -r lanczos --processes 16 --verbose --zoom=5"
OPTIONS2="-w openlayers -c MUAVLLC --no-kml --resume -r lanczos"
TIME1="/usr/bin/time -v -o"
TIME2="/usr/bin/time -v --append -o"
MYDIR1=/home/pi/gustafson/avare.charts.git/sm/maps

for a in *tif; do
    b=`basename $a .tif`;
    gdal_translate -of vrt -a_nodata '0 0 0' -expand rgb ${b}.tif ${b}_1.vrt
    gdalwarp -of vrt -t_srs 'EPSG:900913' ${b}_1.vrt ${b}_2.vrt;

    /home/pi/gustafson/avare.charts.git/sm/maps/gdal2tiles_512_parallel.py --verbose -t "Tactical Pilotage Charts" ${OPTIONS2} ${b}_2.vrt ${b}_test;done
done 


gdalbuildvrt -resolution highest -overwrite tpc.vrt *_2.vrt
gdalbuildvrt -resolution lowest -overwrite tpc2.vrt *_2.vrt

#gdal_translate -of vrt -projwin -180 85 180 -85 tpc.vrt tpc2.vrt
