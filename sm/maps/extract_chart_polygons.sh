
## 
## ## Sectional
## pushd merge/sec > /dev/null
## ln -s ../../extract_chart_polygons.py temp.py
## sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh
## 
## bash temp.sh *_c.vrt |
##     while read a b; do
## 	echo $a $b |cut -c3-|sed s/_c.vrt// 
##     done
## rm temp.py
## rm temp.sh
## 
## popd > /dev/null
## 
## 
## ## WAC
## pushd merge/wac > /dev/null
## ln -s ../../extract_chart_polygons.py temp.py
## sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh
## 
## bash temp.sh *_c.vrt |
##     while read a b; do
## 	echo $a $b |cut -c3-|sed s/_c.vrt//
##     done
## rm temp.py
## rm temp.sh
## 
## popd > /dev/null
## 
## ## TAC
## pushd merge/tac > /dev/null
## ln -s ../../extract_chart_polygons.py temp.py
## sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh
## 
## bash temp.sh *_c.vrt |
##     while read a b; do
## 	echo $a $b |cut -c4-|sed s/_c.vrt//
##     done
## rm temp.py
## rm temp.sh
## 
## popd > /dev/null
## 

## TAC
pushd merge/heli > /dev/null
ln -s ../../extract_chart_polygons.py temp.py
sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh

bash temp.sh *_2.vrt |
    while read a b; do
	echo $a $b |sed s/_2.vrt//
    done
rm temp.py
rm temp.sh

popd > /dev/null


## ## IFA
## pushd charts/ifa > /dev/null
## ln -s ../../extract_chart_polygons.py temp.py
## sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh
## 
## for a in *.tif; do
##     gdalwarp -of vrt -t_srs 'EPSG:900913' $a ${a}.vrt
## done
## bash temp.sh *vrt|
##     while read a b; do
## 	echo $a $b |cut -c1-4,9-|sed s/.tif//
##     done
## rm *vrt
## rm temp.py
## rm temp.sh
## 
## popd > /dev/null

## function spinit(){
##     echo $1 $2 $3
##     echo $1 $2 $5
##     echo $1 $4 $5
##     echo $1 $4 $3
## }
## 
## spinit EHUS_AK -180.00 75.00 -125.00 50.00
## spinit EHUS_NE  -85.00 50.15  -40.00 38.00 
## spinit EHUS_NC -110.00 50.15  -85.00 38.00 
## spinit EHUS_NW -131.21 50.15 -110.00 38.00 
## spinit EHUS_SE  -85.00 38.00  -40.00 23.13 
## spinit EHUS_SC -110.00 38.00  -85.00 23.13 
## spinit EHUS_SW -131.21 38.00 -110.00 23.13 
## 
## spinit ELUS_AK -180.00 75.00 -125.00 50.00
## spinit ELUS_NE  -85.00 50.15  -40.00 38.00 
## spinit ELUS_NC -110.00 50.15  -85.00 38.00 
## spinit ELUS_NW -131.21 50.15 -110.00 38.00 
## spinit ELUS_SE  -85.00 38.00  -40.00 23.13 
## spinit ELUS_SC -110.00 38.00  -85.00 23.13 
## spinit ELUS_SW -131.21 38.00 -110.00 23.13 
## 
## spinit REL_AK -180.00 75.00 -125.00 50.00
## spinit REL_NE  -85.00 50.15  -40.00 38.00 
## spinit REL_NC -110.00 50.15  -85.00 38.00 
## spinit REL_NW -131.21 50.15 -110.00 38.00 
## spinit REL_SE  -85.00 38.00  -40.00 23.13 
## spinit REL_SC -110.00 38.00  -85.00 23.13 
## spinit REL_SW -131.21 38.00 -110.00 23.13 
## 
## spinit ELEV_AK -180.00 75.00 -125.00 50.00
## spinit ELEV_NE  -85.00 50.15  -40.00 38.00 
## spinit ELEV_NC -110.00 50.15  -85.00 38.00 
## spinit ELEV_NW -131.21 50.15 -110.00 38.00 
## spinit ELEV_SE  -85.00 38.00  -40.00 23.13 
## spinit ELEV_SC -110.00 38.00  -85.00 23.13 
## spinit ELEV_SW -131.21 38.00 -110.00 23.13 
