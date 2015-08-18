rm polygons.*.txt

## Sectional
pushd merge/sec > /dev/null
ln -s ../../extract_chart_polygons.py temp.py
sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh

bash temp.sh *_c.vrt |
    while read a b; do
	echo $a $b |cut -c3-|sed s/_c.vrt// >> ../../polygons.sec.txt
    done
rm temp.py
rm temp.sh

popd > /dev/null


## WAC
pushd merge/wac > /dev/null
ln -s ../../extract_chart_polygons.py temp.py
sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh

bash temp.sh *_c.vrt |
    while read a b; do
	echo $a $b |cut -c3-|sed s/_c.vrt// >> ../../polygons.wac.txt
    done
rm temp.py
rm temp.sh

popd > /dev/null

## TAC
pushd merge/tac > /dev/null
ln -s ../../extract_chart_polygons.py temp.py
sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh

bash temp.sh *_c.vrt |
    while read a b; do
	echo $a $b |cut -c4-|sed s/_c.vrt// >> ../../polygons.tac.txt
    done
rm temp.py
rm temp.sh

popd > /dev/null


## HELI
pushd merge/heli > /dev/null
ln -s ../../extract_chart_polygons.py temp.py
sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh

bash temp.sh *_3.vrt |
    while read a b; do
	echo ${a}Heli $b |sed s/_3.vrt// >> ../../polygons.heli.txt
	echo ${a} |sed s/_3.vrt// >> tmp.txt
    done
bash temp.sh `ls *_2.vrt | grep -v -f tmp.txt |grep -vi longisl` |
    while read a b; do
	echo ${a}Heli $b | sed s/_2.vrt// >> ../../polygons.heli.txt
    done
rm tmp.txt
rm temp.py
rm temp.sh
popd > /dev/null


## IFA
pushd charts/ifa > /dev/null
ln -s ../../extract_chart_polygons.py temp.py
sed s/extract_chart_polygons.py/temp.py/ ../../extract_corners.sh > temp.sh

for a in *.tif; do
    gdalwarp -of vrt -t_srs 'EPSG:900913' $a ${a}.vrt
done
bash temp.sh *vrt|
    while read a b; do
	echo $a $b |cut -c1-4,9-|sed s/.tif.vrt// >> ../../polygons.ifa.txt
    done
rm *vrt
rm temp.py
rm temp.sh

popd > /dev/null


## Can TOPO
pushd ../can-topo/ > /dev/null
ln -s ../maps/extract_chart_polygons.py temp.py
sed s/extract_chart_polygons.py/temp.py/ ../maps/extract_corners.sh > temp.sh

bash temp.sh `ls *.vrt|grep -v can-topo` |
    while read a b; do
	a=`echo $a |sed s/.vrt//`
	echo CAN_$a $b >> ../maps/polygons.topo.txt
    done
#rm temp.py
#rm temp.sh

popd > /dev/null


function spinit(){
    echo $1 $2 $3
    echo $1 $2 $5
    echo $1 $4 $5
    echo $1 $4 $3
}

spinit EHUS_AK -180.00 75.00 -125.00 50.00 >> polygons.eh.txt
spinit EHUS_NE  -85.00 50.15  -40.00 38.00 >> polygons.eh.txt 
spinit EHUS_NC -110.00 50.15  -85.00 38.00 >> polygons.eh.txt 
spinit EHUS_NW -131.21 50.15 -110.00 38.00 >> polygons.eh.txt 
spinit EHUS_SE  -85.00 38.00  -40.00 23.13 >> polygons.eh.txt 
spinit EHUS_SC -110.00 38.00  -85.00 23.13 >> polygons.eh.txt 
spinit EHUS_SW -131.21 38.00 -110.00 23.13 >> polygons.eh.txt 

spinit ELUS_AK -180.00 75.00 -125.00 50.00 >> polygons.el.txt
spinit ELUS_NE  -85.00 50.15  -40.00 38.00 >> polygons.el.txt 
spinit ELUS_NC -110.00 50.15  -85.00 38.00 >> polygons.el.txt 
spinit ELUS_NW -131.21 50.15 -110.00 38.00 >> polygons.el.txt 
spinit ELUS_SE  -85.00 38.00  -40.00 23.13 >> polygons.el.txt 
spinit ELUS_SC -110.00 38.00  -85.00 23.13 >> polygons.el.txt 
spinit ELUS_SW -131.21 38.00 -110.00 23.13 >> polygons.el.txt 

spinit REL_AK -180.00 75.00 -125.00 50.00  >> polygons.rel.txt
spinit REL_NE  -85.00 50.15  -40.00 38.00  >> polygons.rel.txt 
spinit REL_NC -110.00 50.15  -85.00 38.00  >> polygons.rel.txt 
spinit REL_NW -131.21 50.15 -110.00 38.00  >> polygons.rel.txt 
spinit REL_SE  -85.00 38.00  -40.00 23.13  >> polygons.rel.txt 
spinit REL_SC -110.00 38.00  -85.00 23.13  >> polygons.rel.txt 
spinit REL_SW -131.21 38.00 -110.00 23.13  >> polygons.rel.txt 

spinit ELEV_AK -180.00 75.00 -125.00 50.00 >> polygons.elev.txt
spinit ELEV_NE  -85.00 50.15  -40.00 38.00 >> polygons.elev.txt 
spinit ELEV_NC -110.00 50.15  -85.00 38.00 >> polygons.elev.txt 
spinit ELEV_NW -131.21 50.15 -110.00 38.00 >> polygons.elev.txt 
spinit ELEV_SE  -85.00 38.00  -40.00 23.13 >> polygons.elev.txt 
spinit ELEV_SC -110.00 38.00  -85.00 23.13 >> polygons.elev.txt 
spinit ELEV_SW -131.21 38.00 -110.00 23.13 >> polygons.elev.txt 


