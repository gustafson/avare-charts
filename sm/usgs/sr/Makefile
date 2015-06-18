#Copyright (c) 2015, Peter A. Gustafson (peter.gustafson@wmich.edu)
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#




## Source is http://nationalmap.gov/small_scale/atlasftp.html#srco48i



clean:
	rm -rf rel48w.tif relakw.tif relprw.tif relhiw.tif relakf.tif tiles maps.db

prepare:
	## gdal_translate -of vrt -srcwin 24000 0 25810 20920 srcoaki0100a.tif srcoaki0100a_1.vrt 
	## gdalwarp -of vrt -t_srs 'EPSG:900913' srcoaki0100a_1.vrt srcoaki0100a_2.vrt 
	gdalwarp -of vrt -t_srs 'EPSG:900913' srcoaki0100a.tif   srcoaki0100a_2.vrt 
	gdalwarp -of vrt -t_srs 'EPSG:900913' srcohii0100a.tif 	 srcohii0100a_2.vrt
	gdalwarp -of vrt -t_srs 'EPSG:900913' srcopri0100a.tif 	 srcopri0100a_2.vrt
	gdalwarp -of vrt -t_srs 'EPSG:900913' srco48i0100a.tif 	 srco48i0100a_2.vrt
	gdalbuildvrt -resolution highest -overwrite relief.vrt srco48i0100a_2.vrt srcoaki0100a_2.vrt srcohii0100a_2.vrt srcopri0100a_2.vrt

sep:
	zip -1 -q relpr.zip `find tiles -name "relprw*.jpeg" -print` 
	zip -1 -q rel48.zip `find tiles -name "rel48w*.jpeg" -print` 
	zip -1 -q relak.zip `find tiles -name "relakw*.jpeg" -print` 
	zip -1 -q relhi.zip `find tiles -name "relhiw*.jpeg" -print`

