## First crop out individual states
for line in `seq 6 61`; do
    sed -n "1,5p;" tl_2018_us_state_EPSG3857.geojson > ${line}.geojson;
    sed -n "${line}p;" tl_2018_us_state_EPSG3857.geojson | sed s/"} },"/"} }"/ >> ${line}.geojson;
    sed -n "62,63p;" tl_2018_us_state_EPSG3857.geojson >> ${line}.geojson;
    ## ## The split across the dataline
    ## ## This is obsolete now that gdal2tiles.py can exclude empty tiles
    ## ogr2ogr -wrapdateline -t_srs EPSG:4326 -clipdst    0 -85 180 85 ${line}.east.tmp.geojson ${line}.geojson;
    ## ogr2ogr -wrapdateline -t_srs EPSG:4326 -clipdst -180 -85   0 85 ${line}.west.tmp.geojson ${line}.geojson;
done

## Then put it into EPSG:3857
for a in *{east,west}.tmp.geojson; do
    ogr2ogr -t_srs EPSG:3857 `basename $a .tmp.geojson`.geojson $a
done

## Then create the convex hull
python convexhull.py

sed s/'"features"'/'"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:EPSG::3857" } },\n"features"'/ -i *convexhull*geojson

