#Copyright (c) 2012, Zubair Khan (governer@gmail.com) 
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

clean:
	rm -rf rel48w.tif relakw.tif relprw.tif relhiw.tif relakf.tif tiles maps.db

prepare:
	mkdir tiles
	gdal_translate -srcwin 24000 0 25810 20920 srcoaki0100a.tif relak.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 relak.tif relakw.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 srcohii0100a.tif relhiw.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 srcopri0100a.tif relprw.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 srco48i0100a.tif rel48w.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow relhiw.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow relakw.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow relprw.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow rel48w.tif
	echo "cd $PWD; mkdir -p tiles/rel/hi; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/rel/hi -ps 512 512 -levels 4 -useDirForEachRow relhiw.tif; wait" | qsub -N hi -l nodes=1:ppn=1
	echo "cd $PWD; mkdir -p tiles/rel/ak; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/rel/ak -ps 512 512 -levels 4 -useDirForEachRow relakw.tif; wait" | qsub -N ak -l nodes=1:ppn=1
	echo "cd $PWD; mkdir -p tiles/rel/pr; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/rel/pr -ps 512 512 -levels 4 -useDirForEachRow relprw.tif; wait" | qsub -N pr -l nodes=1:ppn=1
	echo "cd $PWD; mkdir -p tiles/rel/48; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/rel/48 -ps 512 512 -levels 4 -useDirForEachRow rel48w.tif; wait" | qsub -N 48 -l nodes=1:ppn=1
	mv tiles/0 tiles/6


#export LD_LIBRARY_PATH=/usr/local/lib
finalize:
	sqlite3 maps.db 'create table files(name varchar(64),lonul float,latul float,lonll float,latll float,lonur float,latur float,lonlr float,latlr float,lonc float,latc float);'
	for file in `find tiles -name "*.tif" -print | sed 's/.tif'// | sort`; do \
		echo $$file ; \
		gdal_translate -of jpeg -co QUALITY=100 $$file.tif $$file.jpeg; \
		rm -f $$file.jpeg.aux.xml ; \
		sqlite3 maps.db "insert into files values(\"$$file.jpeg\",`gdalinfo $$file.tif | grep "Upper Left" | sed 's/Upper Left\s*(\s*//' | sed 's/).*//'`, `gdalinfo $$file.tif | grep "Lower Left" | sed 's/Lower Left\s*(\s*//' | sed 's/).*//'`, `gdalinfo $$file.tif | grep "Upper Right" | sed 's/Upper Right\s*(\s*//' | sed 's/).*//'`, `gdalinfo $$file.tif | grep "Lower Right" | sed 's/Lower Right\s*(\s*//' | sed 's/).*//'`, `gdalinfo $$file.tif | grep "Center" | sed 's/Center\s*(\s*//' | sed 's/).*//'`);" ; \
	done

sep:
	zip -1 -q relpr.zip `find tiles -name "relprw*.jpeg" -print` 
	zip -1 -q rel48.zip `find tiles -name "rel48w*.jpeg" -print` 
	zip -1 -q relak.zip `find tiles -name "relakw*.jpeg" -print` 
	zip -1 -q relhi.zip `find tiles -name "relhiw*.jpeg" -print`

