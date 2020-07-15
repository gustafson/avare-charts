tac.vrt: warped
	gdalbuildvrt -r cubicspline -srcnodata 51 -vrtnodata 51 -resolution highest tac.vrt -overwrite merge/tac/*.tif

warped: \
merge/tac/Baltimore-WashingtonTAC.tif \
merge/tac/PhiladelphiaTAC.tif \
merge/tac/NewYorkTAC.tif \
merge/tac/DetroitTAC.tif \
merge/tac/PittsburghTAC.tif \
merge/tac/ClevelandTAC.tif \
merge/tac/OrlandoTAC.tif \
merge/tac/TampaTAC.tif \
merge/tac/DenverTAC.tif \
merge/tac/ColoradoSpringsTAC.tif \
merge/tac/LosAngelesTAC.tif \
merge/tac/SanDiegoTAC.tif \
merge/tac/AnchorageTAC.tif \
merge/tac/AtlantaTAC.tif \
merge/tac/BostonTAC.tif \
merge/tac/CharlotteTAC.tif \
merge/tac/ChicagoTAC.tif \
merge/tac/CincinnatiTAC.tif \
merge/tac/Dallas-FtWorthTAC.tif \
merge/tac/FairbanksTAC.tif \
merge/tac/HoustonTAC.tif \
merge/tac/KansasCityTAC.tif \
merge/tac/LasVegasTAC.tif \
merge/tac/MemphisTAC.tif \
merge/tac/MiamiTAC.tif \
merge/tac/Minneapolis-StPaulTAC.tif \
merge/tac/NewOrleansTAC.tif \
merge/tac/PhoenixTAC.tif \
merge/tac/PuertoRico-VITAC.tif \
merge/tac/SaltLakeCityTAC.tif \
merge/tac/SanFranciscoTAC.tif \
merge/tac/SeattleTAC.tif \
merge/tac/StLouisTAC.tif \
merge/tac/HonoluluInset.tif

merge/tac/AnchorageTAC.tif: charts/tac/AnchorageTAC*
	rm -f merge/tac/*AnchorageTAC*
	grep AnchorageTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/AnchorageTAC*.tif|grep -vi planning | tail -n1` merge/tac/runAnchorageTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/AnchorageTAC.geojson -crop_to_cutline merge/tac/runAnchorageTAC_1.vrt merge/tac/AnchorageTAC.tif
	rm -f merge/tac/runAnchorageTAC*.vrt

merge/tac/AtlantaTAC.tif: charts/tac/AtlantaTAC*
	rm -f merge/tac/*AtlantaTAC*
	grep AtlantaTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/AtlantaTAC*.tif|grep -vi planning | tail -n1` merge/tac/runAtlantaTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/AtlantaTAC.geojson -crop_to_cutline merge/tac/runAtlantaTAC_1.vrt merge/tac/AtlantaTAC.tif
	rm -f merge/tac/runAtlantaTAC*.vrt

merge/tac/Baltimore-WashingtonTAC.tif: charts/tac/Baltimore-WashingtonTAC*
	rm -f merge/tac/*Baltimore-WashingtonTAC*
	grep Baltimore ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Baltimore-WashingtonTAC*.tif|grep -vi planning | tail -n1` merge/tac/runBaltimore-WashingtonTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/Baltimore-WashingtonTAC.geojson -crop_to_cutline merge/tac/runBaltimore-WashingtonTAC_1.vrt merge/tac/Baltimore-WashingtonTAC.tif
	rm -f merge/tac/runBaltimore-WashingtonTAC*.vrt

merge/tac/BostonTAC.tif: charts/tac/BostonTAC*
	rm -f merge/tac/*BostonTAC*
	grep BostonTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/BostonTAC*.tif|grep -vi planning | tail -n1` merge/tac/runBostonTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/BostonTAC.geojson -crop_to_cutline merge/tac/runBostonTAC_1.vrt merge/tac/BostonTAC.tif
	rm -f merge/tac/runBostonTAC*.vrt

merge/tac/CharlotteTAC.tif: charts/tac/CharlotteTAC*
	rm -f merge/tac/*CharlotteTAC*
	grep CharlotteTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f	
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/CharlotteTAC*.tif|grep -vi planning | tail -n1` merge/tac/runCharlotteTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/CharlotteTAC.geojson -crop_to_cutline merge/tac/runCharlotteTAC_1.vrt merge/tac/CharlotteTAC.tif
	rm -f merge/tac/runCharlotteTAC*.vrt

merge/tac/ChicagoTAC.tif: charts/tac/ChicagoTAC*
	rm -f merge/tac/*ChicagoTAC*
	grep ChicagoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ChicagoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runChicagoTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/ChicagoTAC.geojson -crop_to_cutline merge/tac/runChicagoTAC_1.vrt merge/tac/ChicagoTAC.tif
	rm -f merge/tac/runChicagoTAC*.vrt

merge/tac/CincinnatiTAC.tif: charts/tac/CincinnatiTAC*
	rm -f merge/tac/*CincinnatiTAC*
	grep CincinnatiTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/CincinnatiTAC*.tif|grep -vi planning | tail -n1` merge/tac/runCincinnatiTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/CincinnatiTAC.geojson -crop_to_cutline merge/tac/runCincinnatiTAC_1.vrt merge/tac/CincinnatiTAC.tif
	rm -f merge/tac/runCincinnatiTAC*.vrt

merge/tac/ClevelandTAC.tif: charts/tac/ClevelandTAC*
	rm -f merge/tac/*ClevelandTAC*
	grep ClevelandTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ClevelandTAC*.tif|grep -vi planning | tail -n1` merge/tac/runClevelandTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/ClevelandTAC.geojson -crop_to_cutline merge/tac/runClevelandTAC_1.vrt merge/tac/ClevelandTAC.tif
	rm -f merge/tac/runClevelandTAC*.vrt

merge/tac/ColoradoSpringsTAC.tif: charts/tac/ColoradoSpringsTAC*
	rm -f merge/tac/*ColoradoSpringsTAC*
	grep ColoradoSpringsTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ColoradoSpringsTAC*.tif|grep -vi planning | tail -n1` merge/tac/runColoradoSpringsTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/ColoradoSpringsTAC.geojson -crop_to_cutline merge/tac/runColoradoSpringsTAC_1.vrt merge/tac/ColoradoSpringsTAC.tif
	rm -f merge/tac/runColoradoSpringsTAC*.vrt

merge/tac/Dallas-FtWorthTAC.tif: charts/tac/Dallas-FtWorthTAC*
	rm -f merge/tac/*Dallas-FtWorthTAC*
	grep Dallas ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Dallas-FtWorthTAC*.tif|grep -vi planning | tail -n1` merge/tac/runDallas-FtWorthTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/Dallas-FtWorthTAC.geojson -crop_to_cutline merge/tac/runDallas-FtWorthTAC_1.vrt merge/tac/Dallas-FtWorthTAC.tif
	rm -f merge/tac/runDallas-FtWorthTAC*.vrt

merge/tac/DenverTAC.tif: charts/tac/DenverTAC*
	rm -f merge/tac/*DenverTAC*
	grep DenverTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/DenverTAC*.tif|grep -vi planning | tail -n1` merge/tac/runDenverTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/DenverTAC.geojson -crop_to_cutline merge/tac/runDenverTAC_1.vrt merge/tac/DenverTAC.tif
	rm -f merge/tac/runDenverTAC*.vrt

merge/tac/DetroitTAC.tif: charts/tac/DetroitTAC*
	rm -f merge/tac/*DetroitTAC*
	grep DetroitTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/DetroitTAC*.tif|grep -vi planning | tail -n1` merge/tac/runDetroitTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/DetroitTAC.geojson -crop_to_cutline merge/tac/runDetroitTAC_1.vrt merge/tac/DetroitTAC.tif
	rm -f merge/tac/runDetroitTAC*.vrt

merge/tac/FairbanksTAC.tif: charts/tac/FairbanksTAC*
	rm -f merge/tac/*FairbanksTAC*
	grep FairbanksTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/FairbanksTAC*.tif|grep -vi planning | tail -n1` merge/tac/runFairbanksTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/FairbanksTAC.geojson -crop_to_cutline merge/tac/runFairbanksTAC_1.vrt merge/tac/FairbanksTAC.tif
	rm -f merge/tac/runFairbanksTAC*.vrt

merge/tac/HoustonTAC.tif: charts/tac/HoustonTAC*
	rm -f merge/tac/*HoustonTAC*
	grep HoustonTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/HoustonTAC*.tif|grep -vi planning | tail -n1` merge/tac/runHoustonTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/HoustonTAC.geojson -crop_to_cutline merge/tac/runHoustonTAC_1.vrt merge/tac/HoustonTAC.tif
	rm -f merge/tac/runHoustonTAC*.vrt

merge/tac/KansasCityTAC.tif: charts/tac/KansasCityTAC*
	rm -f merge/tac/*KansasCityTAC*
	grep KansasCityTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/KansasCityTAC*.tif|grep -vi planning | tail -n1` merge/tac/runKansasCityTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/KansasCityTAC.geojson -crop_to_cutline merge/tac/runKansasCityTAC_1.vrt merge/tac/KansasCityTAC.tif
	rm -f merge/tac/runKansasCityTAC*.vrt

merge/tac/LasVegasTAC.tif: charts/tac/LasVegasTAC*
	rm -f merge/tac/*LasVegasTAC*
	grep LasVegasTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/LasVegasTAC*.tif|grep -vi planning | tail -n1` merge/tac/runLasVegasTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/LasVegasTAC.geojson -crop_to_cutline merge/tac/runLasVegasTAC_1.vrt merge/tac/LasVegasTAC.tif
	rm -f merge/tac/runLasVegasTAC*.vrt

merge/tac/LosAngelesTAC.tif: charts/tac/LosAngelesTAC*
	rm -f merge/tac/*LosAngelesTAC*
	grep LosAngelesTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/LosAngelesTAC*.tif|grep -vi planning | tail -n1` merge/tac/runLosAngelesTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/LosAngelesTAC.geojson -crop_to_cutline merge/tac/runLosAngelesTAC_1.vrt merge/tac/LosAngelesTAC.tif
	rm -f merge/tac/runLosAngelesTAC*.vrt


merge/tac/MemphisTAC.tif: charts/tac/MemphisTAC*
	rm -f merge/tac/*MemphisTAC*
	grep MemphisTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/MemphisTAC*.tif|grep -vi planning | tail -n1` merge/tac/runMemphisTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/MemphisTAC.geojson -crop_to_cutline merge/tac/runMemphisTAC_1.vrt merge/tac/MemphisTAC.tif
	rm -f merge/tac/runMemphisTAC*.vrt

merge/tac/MiamiTAC.tif: charts/tac/MiamiTAC*
	rm -f merge/tac/*MiamiTAC*
	grep MiamiTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/MiamiTAC*.tif|grep -vi planning | tail -n1` merge/tac/runMiamiTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/MiamiTAC.geojson -crop_to_cutline merge/tac/runMiamiTAC_1.vrt merge/tac/MiamiTAC.tif
	rm -f merge/tac/runMiamiTAC*.vrt

merge/tac/Minneapolis-StPaulTAC.tif: charts/tac/Minneapolis-StPaulTAC*
	rm -f merge/tac/*Minneapolis-StPaulTAC*
	grep Minneapolis ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Minneapolis-StPaulTAC*.tif|grep -vi planning | tail -n1` merge/tac/runMinneapolis-StPaulTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/Minneapolis-StPaulTAC.geojson -crop_to_cutline merge/tac/runMinneapolis-StPaulTAC_1.vrt merge/tac/Minneapolis-StPaulTAC.tif
	rm -f merge/tac/runMinneapolis-StPaulTAC*.vrt

merge/tac/NewOrleansTAC.tif: charts/tac/NewOrleansTAC*
	rm -f merge/tac/*NewOrleansTAC*
	grep NewOrleansTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/NewOrleansTAC*.tif|grep -vi planning | tail -n1` merge/tac/runNewOrleansTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/NewOrleansTAC.geojson -crop_to_cutline merge/tac/runNewOrleansTAC_1.vrt merge/tac/NewOrleansTAC.tif
	rm -f merge/tac/runNewOrleansTAC*.vrt

merge/tac/NewYorkTAC.tif: charts/tac/NewYorkTAC*
	rm -f merge/tac/*NewYorkTAC*
	grep NewYorkTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/NewYorkTAC*.tif|grep -vi planning | tail -n1` merge/tac/runNewYorkTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/NewYorkTAC.geojson -crop_to_cutline merge/tac/runNewYorkTAC_1.vrt merge/tac/NewYorkTAC.tif
	rm -f merge/tac/runNewYorkTAC*.vrt

merge/tac/OrlandoTAC.tif: charts/tac/OrlandoTAC*
	rm -f merge/tac/*OrlandoTAC*
	grep OrlandoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/OrlandoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runOrlandoTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/OrlandoTAC.geojson -crop_to_cutline merge/tac/runOrlandoTAC_1.vrt merge/tac/OrlandoTAC.tif
	rm -f merge/tac/runOrlandoTAC*.vrt

merge/tac/PhiladelphiaTAC.tif: charts/tac/PhiladelphiaTAC*
	rm -f merge/tac/*PhiladelphiaTAC*
	grep PhiladelphiaTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PhiladelphiaTAC*.tif|grep -vi planning | tail -n1` merge/tac/runPhiladelphiaTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PhiladelphiaTAC.geojson -crop_to_cutline merge/tac/runPhiladelphiaTAC_1.vrt merge/tac/PhiladelphiaTAC.tif
	rm -f merge/tac/runPhiladelphiaTAC*.vrt

merge/tac/PhoenixTAC.tif: charts/tac/PhoenixTAC*
	rm -f merge/tac/*PhoenixTAC*
	grep PhoenixTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PhoenixTAC*.tif|grep -vi planning | tail -n1` merge/tac/runPhoenixTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PhoenixTAC.geojson -crop_to_cutline merge/tac/runPhoenixTAC_1.vrt merge/tac/PhoenixTAC.tif
	rm -f merge/tac/runPhoenixTAC*.vrt

merge/tac/PittsburghTAC.tif: charts/tac/PittsburghTAC*
	rm -f merge/tac/*PittsburghTAC*
	grep PittsburghTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PittsburghTAC*.tif|grep -vi planning | tail -n1` merge/tac/runPittsburghTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PittsburghTAC.geojson -crop_to_cutline merge/tac/runPittsburghTAC_1.vrt merge/tac/PittsburghTAC.tif
	rm -f merge/tac/runPittsburghTAC*.vrt

merge/tac/PuertoRico-VITAC.tif: charts/tac/PuertoRico-VITAC*
	rm -f merge/tac/*PuertoRico-VITAC*
	grep PuertoRico ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PuertoRico-VITAC*.tif|grep -vi planning | tail -n1` merge/tac/runPuertoRico-VITAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/PuertoRico-VITAC.geojson -crop_to_cutline merge/tac/runPuertoRico-VITAC_1.vrt merge/tac/PuertoRico-VITAC.tif
	rm -f merge/tac/runPuertoRico-VITAC*.vrt

merge/tac/SaltLakeCityTAC.tif: charts/tac/SaltLakeCityTAC*
	rm -f merge/tac/*SaltLakeCityTAC*
	grep SaltLakeCityTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SaltLakeCityTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSaltLakeCityTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SaltLakeCityTAC.geojson -crop_to_cutline merge/tac/runSaltLakeCityTAC_1.vrt merge/tac/SaltLakeCityTAC.tif
	rm -f merge/tac/runSaltLakeCityTAC*.vrt

merge/tac/SanDiegoTAC.tif: charts/tac/SanDiegoTAC*
	rm -f merge/tac/*SanDiegoTAC*
	grep SanDiegoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SanDiegoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSanDiegoTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SanDiegoTAC.geojson -crop_to_cutline merge/tac/runSanDiegoTAC_1.vrt merge/tac/SanDiegoTAC.tif
	rm -f merge/tac/runSanDiegoTAC*.vrt

merge/tac/SanFranciscoTAC.tif: charts/tac/SanFranciscoTAC*
	rm -f merge/tac/*SanFranciscoTAC*
	grep SanFranciscoTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SanFranciscoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSanFranciscoTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SanFranciscoTAC.geojson -crop_to_cutline merge/tac/runSanFranciscoTAC_1.vrt merge/tac/SanFranciscoTAC.tif
	rm -f merge/tac/runSanFranciscoTAC*.vrt

merge/tac/SeattleTAC.tif: charts/tac/SeattleTAC*
	rm -f merge/tac/*SeattleTAC*
	grep SeattleTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SeattleTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSeattleTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/SeattleTAC.geojson -crop_to_cutline merge/tac/runSeattleTAC_1.vrt merge/tac/SeattleTAC.tif
	rm -f merge/tac/runSeattleTAC*.vrt

merge/tac/StLouisTAC.tif: charts/tac/StLouisTAC*
	rm -f merge/tac/*StLouisTAC*
	grep StLouisTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/StLouisTAC*.tif|grep -vi planning | tail -n1` merge/tac/runStLouisTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/StLouisTAC.geojson -crop_to_cutline merge/tac/runStLouisTAC_1.vrt merge/tac/StLouisTAC.tif
	rm -f merge/tac/runStLouisTAC*.vrt

merge/tac/TampaTAC.tif: charts/tac/TampaTAC*
	rm -f merge/tac/*TampaTAC*
	grep TampaTAC ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/TampaTAC*.tif|grep -vi planning | tail -n1` merge/tac/runTampaTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/TampaTAC.geojson -crop_to_cutline merge/tac/runTampaTAC_1.vrt merge/tac/TampaTAC.tif
	rm -f merge/tac/runTampaTAC*.vrt

merge/tac/HonoluluInset.tif: charts/tac/HonoluluInset*
	rm -f merge/tac/*HonoluluInset*
	grep HonoluluInset ./charts/tac/TileManifest.tac.list |cut -f2 -d:|awk '{print "tiles/1-build/" $$1}' |xargs rm -f
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/HonoluluInset*.tif|grep -vi planning | tail -n1` merge/tac/runHonoluluInset_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/HonoluluInset.geojson -crop_to_cutline merge/tac/runHonoluluInset_1.vrt merge/tac/HonoluluInset.tif
	rm -f merge/tac/runHonoluluInset*.vrt
