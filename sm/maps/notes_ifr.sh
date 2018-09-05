## rm time-ifr-low-warps.time
## rm -fr /dev/shm/merge/ifr && mkdir -p /dev/shm/merge/ifr
## rm -fr merge/ifr && mkdir -p merge/ifr

## ./stage-ifr-low 1|grep -v crop > /dev/shm/tmp.sh
## bash /dev/shm/tmp.sh && rm /dev/shm/tmp.sh



echo cd $PWD > /dev/shm/job.pbs
COUNT=0
## Do in this order because pacific etc takes a long time
for ORDER in ENR_P ENR_A ENR_L; do
    ./stage-ifr-low 1| grep gdalwarp | grep $ORDER > /dev/shm/tmp.sh

    while read COMMAND; do
	echo "[[ \${PBS_ARRAYID} -eq ${COUNT} ]] && $COMMAND" >> /dev/shm/job.pbs
	let COUNT+=1
    done < /dev/shm/tmp.sh
done

JOBID=$(qsub -t 0-195 -l nodes=1:ppn=4 -l mem=6gb -l walltime=1000:00:00 -V -N ifrwarp /dev/shm/job.pbs)

sleep 1

echo cd $PWD > /dev/shm/job.pbs
echo "rm -f ifr-east.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin  127.5 55.0 180.0 -5.25 -a_nodata 51 -of vrt merge/ifr/*easternhemisphere*tif ifr-east.vrt" >> /dev/shm/job.pbs
echo "rm -f ifr-west.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72   -62.5 -5.25 -a_nodata 51 -of vrt merge/ifr/*westernhemisphere*tif ifr-west.vrt" >> /dev/shm/job.pbs
JOBID=$(qsub -W depend=afterok:$JOBID -l nodes=1:ppn=4 -l mem=6gb -l walltime=1000:00:00 -V -N ifrgather /dev/shm/job.pbs)
qsub -W depend=afterok:$JOBID -t3 generate-tiles.pbs

rm /dev/shm/job.pbs

