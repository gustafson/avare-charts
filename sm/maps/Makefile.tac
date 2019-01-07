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
merge/tac/StLouisTAC.tif

merge/tac/Baltimore-WashingtonTAC.tif: charts/tac/Baltimore-WashingtonTAC*.tif
	rm -f merge/tac/*Baltimore-WashingtonTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Baltimore-WashingtonTAC*.tif|grep -vi planning | tail -n1` merge/tac/runBaltimore-WashingtonTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runBaltimore-WashingtonTAC_1.vrt merge/tac/runBaltimore-WashingtonTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -78.34342 39.800000 -75.770000 38.166700 merge/tac/runBaltimore-WashingtonTAC_2.vrt merge/tac/Baltimore-WashingtonTAC.tif # -78.600000
	rm -f merge/tac/runBaltimore-WashingtonTAC*.vrt

merge/tac/PhiladelphiaTAC.tif: charts/tac/PhiladelphiaTAC*.tif
	rm -f merge/tac/*PhiladelphiaTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PhiladelphiaTAC*.tif|grep -vi planning | tail -n1` merge/tac/runPhiladelphiaTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runPhiladelphiaTAC_1.vrt merge/tac/runPhiladelphiaTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -75.916667 40.500000 -74.516667 39.383330 merge/tac/runPhiladelphiaTAC_2.vrt merge/tac/PhiladelphiaTAC.tif
	rm -f merge/tac/runPhiladelphiaTAC*.vrt

merge/tac/NewYorkTAC.tif: charts/tac/NewYorkTAC*.tif
	rm -f merge/tac/*NewYorkTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/NewYorkTAC*.tif|grep -vi planning | tail -n1` merge/tac/runNewYorkTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runNewYorkTAC_1.vrt merge/tac/runNewYorkTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q merge/tac/runNewYorkTAC_2.vrt merge/tac/NewYorkTAC.tif #-projwin_srs WGS84 -projwin -75.600000 41.300000 -72.660000 40.220000 
	rm -f merge/tac/runNewYorkTAC*.vrt

merge/tac/DetroitTAC.tif: charts/tac/DetroitTAC*.tif
	rm -f merge/tac/*DetroitTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/DetroitTAC*.tif|grep -vi planning | tail -n1` merge/tac/runDetroitTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runDetroitTAC_1.vrt merge/tac/runDetroitTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -84.800000 42.750000 -82.660000 41.420000 merge/tac/runDetroitTAC_2.vrt merge/tac/DetroitTAC.tif
	rm -f merge/tac/runDetroitTAC*.vrt

merge/tac/PittsburghTAC.tif: charts/tac/PittsburghTAC*.tif
	rm -f merge/tac/*PittsburghTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PittsburghTAC*.tif|grep -vi planning | tail -n1` merge/tac/runPittsburghTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runPittsburghTAC_1.vrt merge/tac/runPittsburghTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -81.000000 41.050000 -79.000000 39.950000 merge/tac/runPittsburghTAC_2.vrt merge/tac/PittsburghTAC.tif
	rm -f merge/tac/runPittsburghTAC*.vrt

merge/tac/ClevelandTAC.tif: charts/tac/ClevelandTAC*.tif
	rm -f merge/tac/*ClevelandTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ClevelandTAC*.tif|grep -vi planning | tail -n1` merge/tac/runClevelandTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runClevelandTAC_1.vrt merge/tac/runClevelandTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -82.900000 41.950000 -80.600000 40.840000 merge/tac/runClevelandTAC_2.vrt merge/tac/ClevelandTAC.tif
	rm -f merge/tac/runClevelandTAC*.vrt

merge/tac/OrlandoTAC.tif: charts/tac/OrlandoTAC*.tif
	rm -f merge/tac/*OrlandoTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/OrlandoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runOrlandoTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runOrlandoTAC_1.vrt merge/tac/runOrlandoTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -82.500000 29.200000 -80.200000 27.800000 merge/tac/runOrlandoTAC_2.vrt merge/tac/OrlandoTAC.tif
	rm -f merge/tac/runOrlandoTAC*.vrt

merge/tac/TampaTAC.tif: charts/tac/TampaTAC*.tif
	rm -f merge/tac/*TampaTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/TampaTAC*.tif|grep -vi planning | tail -n1` merge/tac/runTampaTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runTampaTAC_1.vrt merge/tac/runTampaTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -83.300000 28.570000 -81.850000 27.250000 merge/tac/runTampaTAC_2.vrt merge/tac/TampaTAC.tif
	rm -f merge/tac/runTampaTAC*.vrt

merge/tac/DenverTAC.tif: charts/tac/DenverTAC*.tif
	rm -f merge/tac/*DenverTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/DenverTAC*.tif|grep -vi planning | tail -n1` merge/tac/runDenverTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runDenverTAC_1.vrt merge/tac/runDenverTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -105.900000 40.600000 -103.730000 39.250000 merge/tac/runDenverTAC_2.vrt merge/tac/DenverTAC.tif
	rm -f merge/tac/runDenverTAC*.vrt

merge/tac/ColoradoSpringsTAC.tif: charts/tac/ColoradoSpringsTAC*.tif
	rm -f merge/tac/*ColoradoSpringsTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ColoradoSpringsTAC*.tif|grep -vi planning | tail -n1` merge/tac/runColoradoSpringsTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runColoradoSpringsTAC_1.vrt merge/tac/runColoradoSpringsTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -106.200000 39.250000 -103.450000 37.650000 merge/tac/runColoradoSpringsTAC_2.vrt merge/tac/ColoradoSpringsTAC.tif
	rm -f merge/tac/runColoradoSpringsTAC*.vrt

merge/tac/LosAngelesTAC.tif: charts/tac/LosAngelesTAC*.tif
	rm -f merge/tac/*LosAngelesTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/LosAngelesTAC*.tif|grep -vi planning | tail -n1` merge/tac/runLosAngelesTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runLosAngelesTAC_1.vrt merge/tac/runLosAngelesTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -120.150000 34.500000 -116.450000 33.370000 merge/tac/runLosAngelesTAC_2.vrt merge/tac/LosAngelesTAC.tif
	rm -f merge/tac/runLosAngelesTAC*.vrt

merge/tac/SanDiegoTAC.tif: charts/tac/SanDiegoTAC*.tif
	rm -f merge/tac/*SanDiegoTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SanDiegoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSanDiegoTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runSanDiegoTAC_1.vrt merge/tac/runSanDiegoTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -117.900000 33.600000 -116.300000 32.500000 merge/tac/runSanDiegoTAC_2.vrt merge/tac/SanDiegoTAC.tif
	rm -f merge/tac/runSanDiegoTAC*.vrt

merge/tac/AnchorageTAC.tif: charts/tac/AnchorageTAC*.tif
	rm -f merge/tac/*AnchorageTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/AnchorageTAC*.tif|grep -vi planning | tail -n1` merge/tac/runAnchorageTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runAnchorageTAC_1.vrt merge/tac/runAnchorageTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -151.85384 61.650000 -148.29861 60.566670 merge/tac/runAnchorageTAC_2.vrt merge/tac/AnchorageTAC.tif #152.000000 -148.000000
	rm -f merge/tac/runAnchorageTAC*.vrt

merge/tac/AtlantaTAC.tif: charts/tac/AtlantaTAC*.tif
	rm -f merge/tac/*AtlantaTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/AtlantaTAC*.tif|grep -vi planning | tail -n1` merge/tac/runAtlantaTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runAtlantaTAC_1.vrt merge/tac/runAtlantaTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -85.30617 34.30840 -83.600000 33.000000 merge/tac/runAtlantaTAC_2.vrt merge/tac/AtlantaTAC.tif #-85.500000 34.400000
	rm -f merge/tac/runAtlantaTAC*.vrt

merge/tac/BostonTAC.tif: charts/tac/BostonTAC*.tif
	rm -f merge/tac/*BostonTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/BostonTAC*.tif|grep -vi planning | tail -n1` merge/tac/runBostonTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runBostonTAC_1.vrt merge/tac/runBostonTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -71.87625 42.900000 -69.55863 41.250000 merge/tac/runBostonTAC_2.vrt merge/tac/BostonTAC.tif # -72.300000 -69.500000
	rm -f merge/tac/runBostonTAC*.vrt

merge/tac/CharlotteTAC.tif: charts/tac/CharlotteTAC*.tif
	rm -f merge/tac/*CharlotteTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/CharlotteTAC*.tif|grep -vi planning | tail -n1` merge/tac/runCharlotteTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runCharlotteTAC_1.vrt merge/tac/runCharlotteTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -81.82989 35.900000 -80.080000 34.580000 merge/tac/runCharlotteTAC_2.vrt merge/tac/CharlotteTAC.tif #-82.100000
	rm -f merge/tac/runCharlotteTAC*.vrt

merge/tac/ChicagoTAC.tif: charts/tac/ChicagoTAC*.tif
	rm -f merge/tac/*ChicagoTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/ChicagoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runChicagoTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/ChicagoTAC.geojson -crop_to_cutline merge/tac/runChicagoTAC_1.vrt merge/tac/ChicagoTAC.tif
	#gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runChicagoTAC_1.vrt merge/tac/runChicagoTAC_2.vrt
	#gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -89.100000 42.500000 -86.900000 41.430000 merge/tac/runChicagoTAC_2.vrt merge/tac/ChicagoTAC.tif
	rm -f merge/tac/runChicagoTAC*.vrt

merge/tac/CincinnatiTAC.tif: charts/tac/CincinnatiTAC*.tif
	rm -f merge/tac/*CincinnatiTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/CincinnatiTAC*.tif|grep -vi planning | tail -n1` merge/tac/runCincinnatiTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runCincinnatiTAC_1.vrt merge/tac/runCincinnatiTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -85.900000 40.100000 -83.700000 38.460000 merge/tac/runCincinnatiTAC_2.vrt merge/tac/CincinnatiTAC.tif
	rm -f merge/tac/runCincinnatiTAC*.vrt

merge/tac/Dallas-FtWorthTAC.tif: charts/tac/Dallas-FtWorthTAC*.tif
	rm -f merge/tac/*Dallas-FtWorthTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Dallas-FtWorthTAC*.tif|grep -vi planning | tail -n1` merge/tac/runDallas-FtWorthTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runDallas-FtWorthTAC_1.vrt merge/tac/runDallas-FtWorthTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -98.500000 33.670000 -95.850000 32.050000 merge/tac/runDallas-FtWorthTAC_2.vrt merge/tac/Dallas-FtWorthTAC.tif
	rm -f merge/tac/runDallas-FtWorthTAC*.vrt

merge/tac/FairbanksTAC.tif: charts/tac/FairbanksTAC*.tif
	rm -f merge/tac/*FairbanksTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/FairbanksTAC*.tif|grep -vi planning | tail -n1` merge/tac/runFairbanksTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runFairbanksTAC_1.vrt merge/tac/runFairbanksTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -150.600000 65.250000 -145.800000 64.150000 merge/tac/runFairbanksTAC_2.vrt merge/tac/FairbanksTAC.tif
	rm -f merge/tac/runFairbanksTAC*.vrt

merge/tac/HoustonTAC.tif: charts/tac/HoustonTAC*.tif
	rm -f merge/tac/*HoustonTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/HoustonTAC*.tif|grep -vi planning | tail -n1` merge/tac/runHoustonTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runHoustonTAC_1.vrt merge/tac/runHoustonTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -96.400000 30.550000 -94.500000 29.100000 merge/tac/runHoustonTAC_2.vrt merge/tac/HoustonTAC.tif
	rm -f merge/tac/runHoustonTAC*.vrt

merge/tac/KansasCityTAC.tif: charts/tac/KansasCityTAC*.tif
	rm -f merge/tac/*KansasCityTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/KansasCityTAC*.tif|grep -vi planning | tail -n1` merge/tac/runKansasCityTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runKansasCityTAC_1.vrt merge/tac/runKansasCityTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -96.000000 40.000000 -94.000000 38.660000 merge/tac/runKansasCityTAC_2.vrt merge/tac/KansasCityTAC.tif
	rm -f merge/tac/runKansasCityTAC*.vrt

merge/tac/LasVegasTAC.tif: charts/tac/LasVegasTAC*.tif
	rm -f merge/tac/*LasVegasTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/LasVegasTAC*.tif|grep -vi planning | tail -n1` merge/tac/runLasVegasTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/LasVegasTAC.geojson -crop_to_cutline merge/tac/runLasVegasTAC_1.vrt merge/tac/LasVegasTAC.tif
	#gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runLasVegasTAC_1.vrt merge/tac/runLasVegasTAC_2.vrt
	#gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -116.300000 36.800000 -113.850000 35.667000 merge/tac/runLasVegasTAC_2.vrt merge/tac/LasVegasTAC.tif
	rm -f merge/tac/runLasVegasTAC*.vrt

merge/tac/MemphisTAC.tif: charts/tac/MemphisTAC*.tif
	rm -f merge/tac/*MemphisTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/MemphisTAC*.tif|grep -vi planning | tail -n1` merge/tac/runMemphisTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runMemphisTAC_1.vrt merge/tac/runMemphisTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -91.150000 35.800000 -88.700000 34.400000 merge/tac/runMemphisTAC_2.vrt merge/tac/MemphisTAC.tif
	rm -f merge/tac/runMemphisTAC*.vrt

merge/tac/MiamiTAC.tif: charts/tac/MiamiTAC*.tif
	rm -f merge/tac/*MiamiTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/MiamiTAC*.tif|grep -vi planning | tail -n1` merge/tac/runMiamiTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runMiamiTAC_1.vrt merge/tac/runMiamiTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -81.450000 26.700000 -79.330000 25.100000 merge/tac/runMiamiTAC_2.vrt merge/tac/MiamiTAC.tif
	rm -f merge/tac/runMiamiTAC*.vrt

merge/tac/Minneapolis-StPaulTAC.tif: charts/tac/Minneapolis-StPaulTAC*.tif
	rm -f merge/tac/*Minneapolis-StPaulTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/Minneapolis-StPaulTAC*.tif|grep -vi planning | tail -n1` merge/tac/runMinneapolis-StPaulTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runMinneapolis-StPaulTAC_1.vrt merge/tac/runMinneapolis-StPaulTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -94.300000 45.500000 -92.000000 44.300000 merge/tac/runMinneapolis-StPaulTAC_2.vrt merge/tac/Minneapolis-StPaulTAC.tif
	rm -f merge/tac/runMinneapolis-StPaulTAC*.vrt

merge/tac/NewOrleansTAC.tif: charts/tac/NewOrleansTAC*.tif
	rm -f merge/tac/*NewOrleansTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/NewOrleansTAC*.tif|grep -vi planning | tail -n1` merge/tac/runNewOrleansTAC_1.vrt
	gdalwarp -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857' -cutline charts/tac/NewOrleansTAC.geojson -crop_to_cutline merge/tac/runNewOrleansTAC_1.vrt merge/tac/NewOrleansTAC.tif
	## gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runNewOrleansTAC_1.vrt merge/tac/runNewOrleansTAC_2.vrt
	## gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -91.500000 30.600000 -89.300000 29.550000 merge/tac/runNewOrleansTAC_2.vrt merge/tac/NewOrleansTAC.tif
	rm -f merge/tac/runNewOrleansTAC*.vrt

merge/tac/PhoenixTAC.tif: charts/tac/PhoenixTAC*.tif
	rm -f merge/tac/*PhoenixTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PhoenixTAC*.tif|grep -vi planning | tail -n1` merge/tac/runPhoenixTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runPhoenixTAC_1.vrt merge/tac/runPhoenixTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -113.500000 34.150000 -111.160000 32.750000 merge/tac/runPhoenixTAC_2.vrt merge/tac/PhoenixTAC.tif
	rm -f merge/tac/runPhoenixTAC*.vrt

merge/tac/PuertoRico-VITAC.tif: charts/tac/PuertoRico-VITAC*.tif
	rm -f merge/tac/*PuertoRico-VITAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/PuertoRico-VITAC*.tif|grep -vi planning | tail -n1` merge/tac/runPuertoRico-VITAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runPuertoRico-VITAC_1.vrt merge/tac/runPuertoRico-VITAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -67.750000 18.760000 -64.220000 17.630000 merge/tac/runPuertoRico-VITAC_2.vrt merge/tac/PuertoRico-VITAC.tif
	rm -f merge/tac/runPuertoRico-VITAC*.vrt

merge/tac/SaltLakeCityTAC.tif: charts/tac/SaltLakeCityTAC*.tif
	rm -f merge/tac/*SaltLakeCityTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SaltLakeCityTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSaltLakeCityTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runSaltLakeCityTAC_1.vrt merge/tac/runSaltLakeCityTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -113.200000 41.500000 -110.650000 40.100000 merge/tac/runSaltLakeCityTAC_2.vrt merge/tac/SaltLakeCityTAC.tif
	rm -f merge/tac/runSaltLakeCityTAC*.vrt

merge/tac/SanFranciscoTAC.tif: charts/tac/SanFranciscoTAC*.tif
	rm -f merge/tac/*SanFranciscoTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SanFranciscoTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSanFranciscoTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runSanFranciscoTAC_1.vrt merge/tac/runSanFranciscoTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -123.800000 38.200000 -121.360000 36.900000 merge/tac/runSanFranciscoTAC_2.vrt merge/tac/SanFranciscoTAC.tif
	rm -f merge/tac/runSanFranciscoTAC*.vrt

merge/tac/SeattleTAC.tif: charts/tac/SeattleTAC*.tif
	rm -f merge/tac/*SeattleTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/SeattleTAC*.tif|grep -vi planning | tail -n1` merge/tac/runSeattleTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runSeattleTAC_1.vrt merge/tac/runSeattleTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -123.600000 48.150000 -121.100000 46.720000 merge/tac/runSeattleTAC_2.vrt merge/tac/SeattleTAC.tif
	rm -f merge/tac/runSeattleTAC*.vrt

merge/tac/StLouisTAC.tif: charts/tac/StLouisTAC*.tif
	rm -f merge/tac/*StLouisTAC*
	gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/tac/StLouisTAC*.tif|grep -vi planning | tail -n1` merge/tac/runStLouisTAC_1.vrt
	gdalwarp -of vrt -r cubicspline -dstnodata 51 -t_srs 'EPSG:3857'  merge/tac/runStLouisTAC_1.vrt merge/tac/runStLouisTAC_2.vrt
	gdal_translate -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin -91.400000 39.300000 -89.250000 38.150000 merge/tac/runStLouisTAC_2.vrt merge/tac/StLouisTAC.tif
	rm -f merge/tac/runStLouisTAC*.vrt

