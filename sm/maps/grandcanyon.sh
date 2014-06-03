#!/bin/bash

TMPFILE=/dev/shm/GCtmp
 
gdal_translate -expand rgb `ls charts/sec/Grand_Canyon_General_Aviation_*.tif` ${TMPFILE}.tif
gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs WGS84 ${TMPFILE}.tif ${TMPFILE}-2.tif
rgb2pct.py -pct `ls charts/sec/*.tif|head -n1` ${TMPFILE}-2.tif GrandCanyon.tif

rm /dev/shm/GCtmp*
