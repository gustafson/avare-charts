rm time-ifr-low-warps.time
rm -fr /dev/shm/merge/ifr && mkdir -p /dev/shm/merge/ifr
rm -fr merge/ifr && mkdir -p merge/ifr

# ls `./stage-ifr-low 1|grep cutline|cut -f17 -d" "`

./stage-ifr-low 1|grep -v crop > /dev/shm/tmp.sh
bash /dev/shm/tmp.sh


#xargs -L9 -P1 bash
#/usr/bin/time -v --append -o time-ifr-low-warps.time

echo cd $PWD > /dev/shm/job.pbs
COUNT=0
## Do in this order because of what takes a log of time
for ORDER in ENR_P ENR_A ENR_L; do
    while read COMMAND; do
	echo "[[ \${PBS_ARRAYID} -eq ${COUNT} ]] && $COMMAND" >> /dev/shm/job.pbs
	let COUNT+=1
    done <<< $(./stage-ifr-low 1| grep gdalwarp | grep $ORDER) 
done

qsub -t 0-195%3 -l nodes=1:ppn=4 -l mem=6gb -l walltime=1000:00:00 -V -N ifrwarp /dev/shm/job.pbs

#xargs -L1 -P3 -I {} /usr/bin/time -v --append -o time-ifr-low-warps.time bash -c {}

## for a in west east; do
##     rm -f merge/ifr/ifr-${a}.vrt; gdalbuildvrt merge/ifr/ifr-${a}.vrt merge/ifr/*${a}.tif
## done
## 
## rm -fr /dev/shm/tiles/3
## rm -f ifr-east.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin  127.5 55.0 180.0 -5.25 -a_nodata 51 -of vrt merge/ifr/ifr-east.vrt ifr-east.vrt
## rm -f ifr-west.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72   -62.5 -5.25 -a_nodata 51 -of vrt merge/ifr/ifr-west.vrt ifr-west.vrt
## 
## qsub -t3 generate-tiles.pbs

