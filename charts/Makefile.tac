# Copyright (c) 2020-2021, Peter A. Gustafson (peter.gustafson@wmich.edu)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

tac.vrt: warped
	gdalbuildvrt -r cubicspline -srcnodata 51 -vrtnodata 51 -resolution highest tac.vrt -overwrite merge/tac/*TAC.vrt

warped: \
merge/tac/Baltimore-WashingtonTAC.vrt \
merge/tac/PhiladelphiaTAC.vrt \
merge/tac/NewYorkTAC.vrt \
merge/tac/DetroitTAC.vrt \
merge/tac/PittsburghTAC.vrt \
merge/tac/ClevelandTAC.vrt \
merge/tac/OrlandoTAC.vrt \
merge/tac/TampaTAC.vrt \
merge/tac/DenverTAC.vrt \
merge/tac/ColoradoSpringsTAC.vrt \
merge/tac/LosAngelesTAC.vrt \
merge/tac/SanDiegoTAC.vrt \
merge/tac/AnchorageTAC.vrt \
merge/tac/AtlantaTAC.vrt \
merge/tac/BostonTAC.vrt \
merge/tac/CharlotteTAC.vrt \
merge/tac/ChicagoTAC.vrt \
merge/tac/CincinnatiTAC.vrt \
merge/tac/Dallas-FtWorthTAC.vrt \
merge/tac/FairbanksTAC.vrt \
merge/tac/HoustonTAC.vrt \
merge/tac/KansasCityTAC.vrt \
merge/tac/LasVegasTAC.vrt \
merge/tac/MemphisTAC.vrt \
merge/tac/MiamiTAC.vrt \
merge/tac/Minneapolis-StPaulTAC.vrt \
merge/tac/NewOrleansTAC.vrt \
merge/tac/PhoenixTAC.vrt \
merge/tac/PortlandTAC.vrt \
merge/tac/PuertoRico-VITAC.vrt \
merge/tac/SaltLakeCityTAC.vrt \
merge/tac/SanFranciscoTAC.vrt \
merge/tac/SeattleTAC.vrt \
merge/tac/StLouisTAC.vrt \
merge/tac/HonoluluInset.vrt

merge/tac/AnchorageTAC.vrt: charts/tac/AnchorageTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*AnchorageTAC*
	grep AnchorageTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/AnchorageTAC*.tif|grep -vi planning | tail -n1` merge/tac/AnchorageTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/AnchorageTAC.geojson -crop_to_cutline merge/tac/AnchorageTAC_rgb.vrt merge/tac/AnchorageTAC.vrt

merge/tac/AtlantaTAC.vrt: charts/tac/AtlantaTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*AtlantaTAC*
	grep AtlantaTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/AtlantaTAC*.tif|grep -vi planning | tail -n1` merge/tac/AtlantaTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/AtlantaTAC.geojson -crop_to_cutline merge/tac/AtlantaTAC_rgb.vrt merge/tac/AtlantaTAC.vrt

merge/tac/Baltimore-WashingtonTAC.vrt: charts/tac/Baltimore-WashingtonTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*Baltimore-WashingtonTAC*
	grep Baltimore ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Baltimore-WashingtonTAC*.tif|grep -vi planning | tail -n1` merge/tac/Baltimore-WashingtonTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/Baltimore-WashingtonTAC.geojson -crop_to_cutline merge/tac/Baltimore-WashingtonTAC_rgb.vrt merge/tac/Baltimore-WashingtonTAC.vrt

merge/tac/BostonTAC.vrt: charts/tac/BostonTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*BostonTAC*
	grep BostonTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/BostonTAC*.tif|grep -vi planning | tail -n1` merge/tac/BostonTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/BostonTAC.geojson -crop_to_cutline merge/tac/BostonTAC_rgb.vrt merge/tac/BostonTAC.vrt

merge/tac/CharlotteTAC.vrt: charts/tac/CharlotteTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*CharlotteTAC*
	grep CharlotteTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/CharlotteTAC*.tif|grep -vi planning | tail -n1` merge/tac/CharlotteTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/CharlotteTAC.geojson -crop_to_cutline merge/tac/CharlotteTAC_rgb.vrt merge/tac/CharlotteTAC.vrt

merge/tac/ChicagoTAC.vrt: charts/tac/ChicagoTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*ChicagoTAC*
	grep ChicagoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ChicagoTAC*.tif|grep -vi planning | tail -n1` merge/tac/ChicagoTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/ChicagoTAC.geojson -crop_to_cutline merge/tac/ChicagoTAC_rgb.vrt merge/tac/ChicagoTAC.vrt

merge/tac/CincinnatiTAC.vrt: charts/tac/CincinnatiTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*CincinnatiTAC*
	grep CincinnatiTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/CincinnatiTAC*.tif|grep -vi planning | tail -n1` merge/tac/CincinnatiTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/CincinnatiTAC.geojson -crop_to_cutline merge/tac/CincinnatiTAC_rgb.vrt merge/tac/CincinnatiTAC.vrt

merge/tac/ClevelandTAC.vrt: charts/tac/ClevelandTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*ClevelandTAC*
	grep ClevelandTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ClevelandTAC*.tif|grep -vi planning | tail -n1` merge/tac/ClevelandTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/ClevelandTAC.geojson -crop_to_cutline merge/tac/ClevelandTAC_rgb.vrt merge/tac/ClevelandTAC.vrt

merge/tac/ColoradoSpringsTAC.vrt: charts/tac/ColoradoSpringsTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*ColoradoSpringsTAC*
	grep ColoradoSpringsTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ColoradoSpringsTAC*.tif|grep -vi planning | tail -n1` merge/tac/ColoradoSpringsTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/ColoradoSpringsTAC.geojson -crop_to_cutline merge/tac/ColoradoSpringsTAC_rgb.vrt merge/tac/ColoradoSpringsTAC.vrt

merge/tac/Dallas-FtWorthTAC.vrt: charts/tac/Dallas-FtWorthTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*Dallas-FtWorthTAC*
	grep Dallas ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Dallas-FtWorthTAC*.tif|grep -vi planning | tail -n1` merge/tac/Dallas-FtWorthTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/Dallas-FtWorthTAC.geojson -crop_to_cutline merge/tac/Dallas-FtWorthTAC_rgb.vrt merge/tac/Dallas-FtWorthTAC.vrt

merge/tac/DenverTAC.vrt: charts/tac/DenverTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*DenverTAC*
	grep DenverTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/DenverTAC*.tif|grep -vi planning | tail -n1` merge/tac/DenverTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/DenverTAC.geojson -crop_to_cutline merge/tac/DenverTAC_rgb.vrt merge/tac/DenverTAC.vrt

merge/tac/DetroitTAC.vrt: charts/tac/DetroitTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*DetroitTAC*
	grep DetroitTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/DetroitTAC*.tif|grep -vi planning | tail -n1` merge/tac/DetroitTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/DetroitTAC.geojson -crop_to_cutline merge/tac/DetroitTAC_rgb.vrt merge/tac/DetroitTAC.vrt

merge/tac/FairbanksTAC.vrt: charts/tac/FairbanksTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*FairbanksTAC*
	grep FairbanksTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/FairbanksTAC*.tif|grep -vi planning | tail -n1` merge/tac/FairbanksTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/FairbanksTAC.geojson -crop_to_cutline merge/tac/FairbanksTAC_rgb.vrt merge/tac/FairbanksTAC.vrt

merge/tac/HoustonTAC.vrt: charts/tac/HoustonTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*HoustonTAC*
	grep HoustonTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/HoustonTAC*.tif|grep -vi planning | tail -n1` merge/tac/HoustonTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/HoustonTAC.geojson -crop_to_cutline merge/tac/HoustonTAC_rgb.vrt merge/tac/HoustonTAC.vrt

merge/tac/KansasCityTAC.vrt: charts/tac/KansasCityTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*KansasCityTAC*
	grep KansasCityTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/KansasCityTAC*.tif|grep -vi planning | tail -n1` merge/tac/KansasCityTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/KansasCityTAC.geojson -crop_to_cutline merge/tac/KansasCityTAC_rgb.vrt merge/tac/KansasCityTAC.vrt

merge/tac/LasVegasTAC.vrt: charts/tac/LasVegasTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*LasVegasTAC*
	grep LasVegasTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/LasVegasTAC*.tif|grep -vi planning | tail -n1` merge/tac/LasVegasTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/LasVegasTAC.geojson -crop_to_cutline merge/tac/LasVegasTAC_rgb.vrt merge/tac/LasVegasTAC.vrt

merge/tac/LosAngelesTAC.vrt: charts/tac/LosAngelesTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*LosAngelesTAC*
	grep LosAngelesTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/LosAngelesTAC*.tif|grep -vi planning | tail -n1` merge/tac/LosAngelesTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/LosAngelesTAC.geojson -crop_to_cutline merge/tac/LosAngelesTAC_rgb.vrt merge/tac/LosAngelesTAC.vrt

merge/tac/MemphisTAC.vrt: charts/tac/MemphisTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*MemphisTAC*
	grep MemphisTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/MemphisTAC*.tif|grep -vi planning | tail -n1` merge/tac/MemphisTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/MemphisTAC.geojson -crop_to_cutline merge/tac/MemphisTAC_rgb.vrt merge/tac/MemphisTAC.vrt

merge/tac/MiamiTAC.vrt: charts/tac/MiamiTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*MiamiTAC*
	grep MiamiTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/MiamiTAC*.tif|grep -vi planning | tail -n1` merge/tac/MiamiTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/MiamiTAC.geojson -crop_to_cutline merge/tac/MiamiTAC_rgb.vrt merge/tac/MiamiTAC.vrt

merge/tac/Minneapolis-StPaulTAC.vrt: charts/tac/Minneapolis-StPaulTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*Minneapolis-StPaulTAC*
	grep Minneapolis ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Minneapolis-StPaulTAC*.tif|grep -vi planning | tail -n1` merge/tac/Minneapolis-StPaulTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/Minneapolis-StPaulTAC.geojson -crop_to_cutline merge/tac/Minneapolis-StPaulTAC_rgb.vrt merge/tac/Minneapolis-StPaulTAC.vrt

merge/tac/NewOrleansTAC.vrt: charts/tac/NewOrleansTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*NewOrleansTAC*
	grep NewOrleansTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/NewOrleansTAC*.tif|grep -vi planning | tail -n1` merge/tac/NewOrleansTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/NewOrleansTAC.geojson -crop_to_cutline merge/tac/NewOrleansTAC_rgb.vrt merge/tac/NewOrleansTAC.vrt

merge/tac/NewYorkTAC.vrt: charts/tac/NewYorkTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*NewYorkTAC*
	grep NewYorkTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/NewYorkTAC*.tif|grep -vi planning | tail -n1` merge/tac/NewYorkTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/NewYorkTAC.geojson -crop_to_cutline merge/tac/NewYorkTAC_rgb.vrt merge/tac/NewYorkTAC.vrt

merge/tac/OrlandoTAC.vrt: charts/tac/OrlandoTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*OrlandoTAC*
	grep OrlandoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/OrlandoTAC*.tif|grep -vi planning | tail -n1` merge/tac/OrlandoTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/OrlandoTAC.geojson -crop_to_cutline merge/tac/OrlandoTAC_rgb.vrt merge/tac/OrlandoTAC.vrt

merge/tac/PhiladelphiaTAC.vrt: charts/tac/PhiladelphiaTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*PhiladelphiaTAC*
	grep PhiladelphiaTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PhiladelphiaTAC*.tif|grep -vi planning | tail -n1` merge/tac/PhiladelphiaTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PhiladelphiaTAC.geojson -crop_to_cutline merge/tac/PhiladelphiaTAC_rgb.vrt merge/tac/PhiladelphiaTAC.vrt

merge/tac/PhoenixTAC.vrt: charts/tac/PhoenixTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*PhoenixTAC*
	grep PhoenixTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PhoenixTAC*.tif|grep -vi planning | tail -n1` merge/tac/PhoenixTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PhoenixTAC.geojson -crop_to_cutline merge/tac/PhoenixTAC_rgb.vrt merge/tac/PhoenixTAC.vrt

merge/tac/PittsburghTAC.vrt: charts/tac/PittsburghTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*PittsburghTAC*
	grep PittsburghTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PittsburghTAC*.tif|grep -vi planning | tail -n1` merge/tac/PittsburghTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PittsburghTAC.geojson -crop_to_cutline merge/tac/PittsburghTAC_rgb.vrt merge/tac/PittsburghTAC.vrt

merge/tac/PortlandTAC.vrt: charts/tac/PortlandTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*PortlandTAC*
	grep PortlandTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PortlandTAC*.tif|grep -vi planning | tail -n1` merge/tac/PortlandTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PortlandTAC.geojson -crop_to_cutline merge/tac/PortlandTAC_rgb.vrt merge/tac/PortlandTAC.vrt

merge/tac/PuertoRico-VITAC.vrt: charts/tac/PuertoRico-VITAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*PuertoRico-VITAC*
	grep PuertoRico ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PuertoRico-VITAC*.tif|grep -vi planning | tail -n1` merge/tac/PuertoRico-VITAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PuertoRico-VITAC.geojson -crop_to_cutline merge/tac/PuertoRico-VITAC_rgb.vrt merge/tac/PuertoRico-VITAC.vrt

merge/tac/SaltLakeCityTAC.vrt: charts/tac/SaltLakeCityTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*SaltLakeCityTAC*
	grep SaltLakeCityTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SaltLakeCityTAC*.tif|grep -vi planning | tail -n1` merge/tac/SaltLakeCityTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SaltLakeCityTAC.geojson -crop_to_cutline merge/tac/SaltLakeCityTAC_rgb.vrt merge/tac/SaltLakeCityTAC.vrt

merge/tac/SanDiegoTAC.vrt: charts/tac/SanDiegoTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*SanDiegoTAC*
	grep SanDiegoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SanDiegoTAC*.tif|grep -vi planning | tail -n1` merge/tac/SanDiegoTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SanDiegoTAC.geojson -crop_to_cutline merge/tac/SanDiegoTAC_rgb.vrt merge/tac/SanDiegoTAC.vrt

merge/tac/SanFranciscoTAC.vrt: charts/tac/SanFranciscoTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*SanFranciscoTAC*
	grep SanFranciscoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SanFranciscoTAC*.tif|grep -vi planning | tail -n1` merge/tac/SanFranciscoTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SanFranciscoTAC.geojson -crop_to_cutline merge/tac/SanFranciscoTAC_rgb.vrt merge/tac/SanFranciscoTAC.vrt

merge/tac/SeattleTAC.vrt: charts/tac/SeattleTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*SeattleTAC*
	grep SeattleTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SeattleTAC*.tif|grep -vi planning | tail -n1` merge/tac/SeattleTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SeattleTAC.geojson -crop_to_cutline merge/tac/SeattleTAC_rgb.vrt merge/tac/SeattleTAC.vrt

merge/tac/StLouisTAC.vrt: charts/tac/StLouisTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*StLouisTAC*
	grep StLouisTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/StLouisTAC*.tif|grep -vi planning | tail -n1` merge/tac/StLouisTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/StLouisTAC.geojson -crop_to_cutline merge/tac/StLouisTAC_rgb.vrt merge/tac/StLouisTAC.vrt

merge/tac/TampaTAC.vrt: charts/tac/TampaTAC*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*TampaTAC*
	grep TampaTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/TampaTAC*.tif|grep -vi planning | tail -n1` merge/tac/TampaTAC_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/TampaTAC.geojson -crop_to_cutline merge/tac/TampaTAC_rgb.vrt merge/tac/TampaTAC.vrt

merge/tac/HonoluluInset.vrt: charts/tac/HonoluluInset*
	[[ -d merge/tac ]] || mkdir -p merge/tac
	rm -f merge/tac/*HonoluluInset*
	grep HonoluluInset ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/HonoluluInset*.tif|grep -vi planning | tail -n1` merge/tac/HonoluluInset_rgb.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/HonoluluInset.geojson -crop_to_cutline merge/tac/HonoluluInset_rgb.vrt merge/tac/HonoluluInset.vrt
