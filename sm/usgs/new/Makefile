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
	rm -rf elev48w.tif elevakw.tif elevprw.tif elevhiw.tif elevakf.tif tiles maps.db elevak.tif elevhi.tif elevpr.tif elev48.tif

prepare:
	mkdir tiles
# -100 to 6175 is 0 to 251 for 25 meter pixel
	gdal_translate -ot Byte -scale -100 6175 0 251 elevhii0100a.tif elevhi.tif
	gdal_translate -ot Byte -scale -100 6175 0 251 elev48i0100a.tif elev48.tif
	gdal_translate -ot Byte -scale -100 6175 0 251 elevpri0100a.tif elevpr.tif
	gdal_translate -ot Byte -scale -100 6175 0 251 elevaki0100a.tif elevakf.tif
# cut east of alaska 
	gdal_translate -srcwin 24000 0 25810 20920 elevakf.tif elevak.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 elev48.tif elev48w.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 elevak.tif elevakw.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 elevhi.tif elevhiw.tif
	gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=8 -multi -r cubicspline -t_srs EPSG:4326 elevpr.tif elevprw.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow elevhiw.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow elevakw.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow elevprw.tif
	## gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles -ps 512 512 -useDirForEachRow elev48w.tif
	echo "cd $PWD; mkdir -p tiles/elev/hi; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/elev/hi -ps 512 512 -levels 4 -useDirForEachRow elevhiw.tif" | qsub -N hi -l nodes=1:ppn=1
	echo "cd $PWD; mkdir -p tiles/elev/ak; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/elev/ak -ps 512 512 -levels 4 -useDirForEachRow elevakw.tif" | qsub -N ak -l nodes=1:ppn=1
	echo "cd $PWD; mkdir -p tiles/elev/pr; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/elev/pr -ps 512 512 -levels 4 -useDirForEachRow elevprw.tif" | qsub -N pr -l nodes=1:ppn=1
	echo "cd $PWD; mkdir -p tiles/elev/48; gdal_retile.py -co COMPRESS=DEFLATE -targetDir tiles/elev/48 -ps 512 512 -levels 4 -useDirForEachRow elev48w.tif" | qsub -N 48 -l nodes=1:ppn=1
	mv tiles/0 tiles/5


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
	zip -1 -q elevpr.zip `find tiles -name "elevprw*.jpeg" -print` 
	zip -1 -q elev48.zip `find tiles -name "elev48w*.jpeg" -print` 
	zip -1 -q elevak.zip `find tiles -name "elevakw*.jpeg" -print` 
	zip -1 -q elevhi.zip `find tiles -name "elevhiw*.jpeg" -print`

