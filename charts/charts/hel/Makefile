EXPD=gdal_translate -of vrt -r cubicspline -a_nodata '0 0 0' -expand rgb 
WARP=gdalwarp -of vrt -r cubicspline -dstnodata '0 0 0' -t_srs 'EPSG:3857'
WAR2=gdalwarp -of gtiff -r cubicspline -dstnodata '0 0 0' -t_srs 'EPSG:3857'
CROP=gdal_translate -of gtiff -r cubicspline -q -projwin_srs WGS84 -projwin

TIF = \
BostonDowntown.tif \
Boston.tif \
Chicago.tif \
ChicagoOHareInset.tif \
Dallas-FtWorth.tif \
Detroit.tif \
EasternLongIsland.tif \
GrandCanyon.tif \
HoustonNorth.tif \
HoustonSouth.tif \
USGulfCoast.tif \
Baltimore.tif \
Washington.tif \
LosAngelesEast.tif \
LosAngelesWest.tif \
NewYork.tif
# DowntownManhattan.tif \ Too small.. hasn't been included

VRT = Houston.vrt USGulfHouston.vrt BaltimoreWashington.vrt LosAngeles.vrt NewYork.vrt

ALL = $(TIF) $(VRT)

heli.vrt: $(ALL)
	gdalbuildvrt -r near -resolution highest $@ -overwrite $^ 

clean:
	rm -f $(ALL) *vrt

%.geojson: %.shp
	ogr2ogr -t_srs EPSG:3857 -segmentize 250 $@ $<

GrandCanyon.tif: GrandCanyonGeneralAviation.tif
	rm -f $@ GrandCanyon*.vrt
	$(EXPD) $< GrandCanyon_1.vrt
	$(WARP) GrandCanyon_1.vrt GrandCanyon.vrt
	$(CROP) $$(grep -i "GrandCanyon" HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm GrandCanyon_1.vrt GrandCanyon.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm

%.tif: %HEL*.tif %HEL.geojson
	$(eval TMPVRT=$(subst .tif,_1.vrt,$@))
	$(eval GEOJSN=$(subst .tif,HEL.geojson,$@))
	rm -f $@ $(TMPVRT)
	$(EXPD) $< $(TMPVRT)
	$(WAR2) -cutline $(GEOJSN) -crop_to_cutline $(TMPVRT) $@ && rm $(TMPVRT)
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm

Houston.vrt: HoustonNorth.tif HoustonSouth.tif
	gdalbuildvrt -r near -resolution highest -overwrite Houston.vrt $^ 

USGulfHouston.vrt: USGulfCoast.tif Houston.vrt
	gdalbuildvrt -r near -resolution highest $@ -overwrite $^

BaltimoreWashington.vrt: Baltimore.tif Washington.tif
	gdalbuildvrt -r near -resolution highest $@ -overwrite $^ 

LosAngeles.vrt: LosAngelesEast.tif LosAngelesWest.tif
	gdalbuildvrt -r near -resolution highest $@ -overwrite $^ #-srcnodata "250" 

NewYork.vrt: EasternLongIsland.tif NewYork.tif
	gdalbuildvrt -r near -resolution highest $@ -overwrite $^ #-srcnodata "250" 

