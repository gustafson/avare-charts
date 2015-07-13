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




## Source http://catalog.data.gov/dataset/usgs-small-scale-dataset-100-meter-resolution-elevation-of-alaska-201212-tiff

prepare:
	## gdal_translate -of vrt -srcwin 24000 0 25810 20920 elevaki0100a.tif elevaki0100a_1.vrt 
	## gdalwarp -of vrt -t_srs 'EPSG:900913' elevaki0100a_1.vrt elevaki0100a_2.vrt 
	gdal_translate -of vrt -ot Byte -scale -100 6175 0 251 elevaki0100a.tif elevaki0100a_1.vrt 
	gdal_translate -of vrt -ot Byte -scale -100 6175 0 251 elevhii0100a.tif elevhii0100a_1.vrt
	gdal_translate -of vrt -ot Byte -scale -100 6175 0 251 elevpri0100a.tif elevpri0100a_1.vrt
	gdal_translate -of vrt -ot Byte -scale -100 6175 0 251 elev48i0100a.tif elev48i0100a_1.vrt
	gdalwarp -of vrt -t_srs 'EPSG:900913' elevaki0100a_1.vrt elevaki0100a_2.vrt
	gdalwarp -of vrt -t_srs 'EPSG:900913' elevhii0100a_1.vrt elevhii0100a_2.vrt
	gdalwarp -of vrt -t_srs 'EPSG:900913' elevpri0100a_1.vrt elevpri0100a_2.vrt
	gdalwarp -of vrt -t_srs 'EPSG:900913' elev48i0100a_1.vrt elev48i0100a_2.vrt
	gdalbuildvrt -resolution highest -overwrite relief.vrt elev48i0100a_2.vrt elevaki0100a_2.vrt elevhii0100a_2.vrt elevpri0100a_2.vrt

sep:
	qsub retiles.pbs
