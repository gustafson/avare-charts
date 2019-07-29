rm time-ifr-low-warps.time
rm -fr /dev/shm/merge/ifr && mkdir -p /dev/shm/merge/ifr
rm -fr merge/ifr && mkdir -p merge/ifr

./stage-ifr-low 1|grep -v crop > /dev/shm/tmp.sh
bash /dev/shm/tmp.sh && rm /dev/shm/tmp.sh

cat <<EOF > /dev/shm/job.pbs
#!/bin/sh -login
#SBATCH --mem-per-cpu=4000
#SBATCH --ntasks=4
#SBATCH --time=1000:00:00
#SBATCH --job-name=ifr-warp
#SBATCH --output=z-logs/arrayJob_%A_%a.out
#SBATCH --error=z-logs/arrayJob_%A_%a.out
#SBATCH --array=0-97

function runthis(){
EOF

echo cd $PWD >> /dev/shm/job.pbs
COUNT=0
## Do in this order because pacific etc takes a long time
for ORDER in ENR_P ENR_A ENR_L; do
    ./stage-ifr-low 1| grep gdalwarp | grep $ORDER > /dev/shm/tmp.sh

    while read COMMAND; do
	echo "if [[ \${1} -eq ${COUNT} ]]; then $COMMAND; fi" >> /dev/shm/job.pbs
	let COUNT+=1
    done < /dev/shm/tmp.sh
done
echo "}" >> /dev/shm/job.pbs
echo >> /dev/shm/job.pbs
echo "runthis \${SLURM_ARRAY_TASK_ID}" >> /dev/shm/job.pbs



JOBID=$(sbatch /dev/shm/job.pbs|cut -d" " -f4)


cat << EOF > /dev/shm/job.pbs
#!/bin/sh -login
rm -fr /dev/shm/tiles/3
EOF
echo cd $PWD >> /dev/shm/job.pbs

echo "rm -f merge/ifr/westernhemisphere.vrt; gdalbuildvrt merge/ifr/westernhemisphere.vrt merge/ifr/*westernhemisphere*tif" >> /dev/shm/job.pbs
echo "rm -f merge/ifr/easternhemisphere.vrt; gdalbuildvrt merge/ifr/easternhemisphere.vrt merge/ifr/*easternhemisphere*tif" >> /dev/shm/job.pbs

echo "rm -f ifr-west.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72   -62.5 -5.25 -a_nodata 51 -of vrt merge/ifr/westernhemisphere.vrt ifr-west.vrt" >> /dev/shm/job.pbs
echo "rm -f ifr-east.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin  127.5 55.0 180.0 -5.25 -a_nodata 51 -of vrt merge/ifr/easternhemisphere.vrt ifr-east.vrt" >> /dev/shm/job.pbs

JOBID=$(sbatch --dependency=afterok:$JOBID /dev/shm/job.pbs|cut -d" " -f4)
echo $JOBID
echo $JOBID
echo $JOBID

sbatch --dependency=afterok:$JOBID -a 3 generate-tiles.pbs
