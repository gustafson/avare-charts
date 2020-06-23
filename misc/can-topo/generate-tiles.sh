rm list.txt

echo This directory are a given latitude, nested directories traverse the latidude range
rm -fr merge; mkdir merge
MERGE=$PWD/merge

for a in `ls */*/*tif`; do
    read lat lon tif <<< $(echo $a|sed "s/\// /g");
    echo $lat $lon
    pushd ${lat}/${lon};
    read west east south north <<< $(grep -A1 "west\|east\|north\|south" *pna*xml| grep -i decim| cut -f2 -d">" | cut -f1 -d"<" | paste -d " "  - - - -)
    popd
    echo ${lat} ${north} ${south} >> list.txt

    gdal_translate -r cubicspline -of vrt -expand rgb ${lat}/${lon}/${tif} ${MERGE}/${lat}_${lon}_rbg.vrt
    gdalbuildvrt -r cubicspline -addalpha -srcnodata '0 0 0' -srcnodata '255 255 255' ${MERGE}/${lat}_${lon}_rbga.vrt ${MERGE}/${lat}_${lon}_rbg.vrt 
    gdalwarp -r cubicspline -of vrt -t_srs 'EPSG:900913' ${MERGE}/${lat}_${lon}_rbga.vrt ${MERGE}/${lat}_${lon}_warped.vrt
    gdal_translate -r cubicspline -of vrt -projwin_srs WGS84 -projwin ${west} ${north} ${east} ${south} ${MERGE}/${lat}_${lon}_warped.vrt ${MERGE}/${lat}_${lon}_cropped.vrt
done

gdalbuildvrt -resolution highest -overwrite can-topo.vrt merge/*_cropped.vrt

for a in `ls -d [0-9]*[0-9]`; do
    gdalbuildvrt -resolution highest -overwrite ${a}.vrt merge/$a*warped.vrt
done
