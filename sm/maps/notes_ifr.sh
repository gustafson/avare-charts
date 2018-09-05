rm time-ifr-low-warps.time
rm -fr /dev/shm/merge/ifr && mkdir -p /dev/shm/merge/ifr
rm -fr merge/ifr && mkdir -p merge/ifr

# ls `./stage-ifr-low 1|grep cutline|cut -f17 -d" "`

./stage-ifr-low 1|grep -v gdalwarp | grep -e ogr2ogr -e gdal |grep AKL > /dev/shm/tmp.sh
    ## xargs -L9 -P1 -I {} /usr/bin/time -v --append -o time-ifr-low-warps.time bash -c {}
bash /dev/shm/tmp.sh


#xargs -L9 -P1 bash
#/usr/bin/time -v --append -o time-ifr-low-warps.time

./stage-ifr-low 1| grep gdalwarp |grep AKL|
    xargs -L1 -P3 -I {} /usr/bin/time -v --append -o time-ifr-low-warps.time bash -c {}

for a in west east; do
    rm -f merge/ifr/ifr-${a}.vrt; gdalbuildvrt merge/ifr/ifr-${a}.vrt merge/ifr/*${a}.tif
done

rm -fr /dev/shm/tiles/3
rm -f ifr-east.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin  127.5 55.0 180.0 -5.25 -a_nodata 51 -of vrt merge/ifr/ifr-east.vrt ifr-east.vrt
rm -f ifr-west.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72   -62.5 -5.25 -a_nodata 51 -of vrt merge/ifr/ifr-west.vrt ifr-west.vrt

qsub -t3 generate-tiles.pbs

