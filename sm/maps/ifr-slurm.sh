rm time-ifr-low-warps.time
rm -fr /dev/shm/merge/ifr && mkdir -p /dev/shm/merge/ifr
rm -fr merge/ifr && mkdir -p merge/ifr

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

./stage-ifr-low 1|grep -v crop > /dev/shm/tmp.sh
bash /dev/shm/tmp.sh && rm /dev/shm/tmp.sh

cat <<EOF > /dev/shm/job1.pbs
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

echo cd $PWD >> /dev/shm/job1.pbs
COUNT=0
## Do in this order because pacific etc takes a long time
for ORDER in ENR_P ENR_A ENR_L; do
    ./stage-ifr-low 1| grep gdalwarp | grep $ORDER > /dev/shm/tmp.sh

    while read COMMAND; do
	echo "if [[ \${1} -eq ${COUNT} ]]; then $COMMAND; fi" >> /dev/shm/job1.pbs
	let COUNT+=1
    done < /dev/shm/tmp.sh
done

cat << EOF >> /dev/shm/job1.pbs
}

runthis \${SLURM_ARRAY_TASK_ID}

echo $?
EOF

JOBID1=$(sbatch --parsable -w osprey /dev/shm/job1.pbs)

cat << EOF > /dev/shm/job2.pbs
#!/bin/sh -login
rm -fr /dev/shm/tiles/3
EOF
echo cd $PWD >> /dev/shm/job2.pbs

cat << EOF >> /dev/shm/job2.pbs
rm -f merge/ifr/westernhemisphere.vrt; gdalbuildvrt merge/ifr/westernhemisphere.vrt merge/ifr/*westernhemisphere*tif
rm -f merge/ifr/easternhemisphere.vrt; gdalbuildvrt merge/ifr/easternhemisphere.vrt merge/ifr/*easternhemisphere*tif
rm -f ifr-west.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72   -62.5 -5.25 -a_nodata 51 -of vrt merge/ifr/westernhemisphere.vrt ifr-west.vrt
rm -f ifr-east.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin  127.5 55.0 180.0 -5.25 -a_nodata 51 -of vrt merge/ifr/easternhemisphere.vrt ifr-east.vrt
EOF

JOBID2=$(sbatch --parsable -w osprey --dependency=afterok:$JOBID1 /dev/shm/job2.pbs)
sbatch --parsable -w osprey --dependency=afterok:$JOBID2 -a 3 generate-tiles.pbs
