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
DowntownManhattan.tif \
EasternLongIsland.tif \
GrandCanyonGeneralAviation.tif \
HoustonNorth.tif \
HoustonSouth.tif \
USGulfCoast.tif \
Baltimore.tif \
Washington.tif \
LosAngelesEast.tif \
LosAngelesWest.tif \
NewYork.tif

VRT = Houston.vrt USGulfHouston.vrt BaltimoreWashington.vrt LosAngeles.vrt NewYork.vrt

ALL = $(TIF) $(VRT)

heli.vrt: $(ALL)
	gdalbuildvrt -r near -resolution highest $@ -overwrite $^ 

clean:
	rm -f $(ALL) *vrt

%.geojson: %.shp
	ogr2ogr -t_srs EPSG:3857 -segmentize 250 $@ $<

## BostonDowntown.tif: BostonDowntown*HEL*.tif
## 	rm -f $@ BostonDowntown*.vrt
## 	$(EXPD) $< BostonDowntown_1.vrt
## 	$(WARP) BostonDowntown_1.vrt BostonDowntown.vrt
## 	$(CROP) $$(grep -i "BostonDowntown " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm BostonDowntown_1.vrt BostonDowntown.vrt
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm
## 
## Detroit.tif: Detroit*HEL*.tif
## 	rm -f $@ Detroit*.vrt
## 	$(EXPD) $< Detroit_1.vrt
## 	$(WARP) Detroit_1.vrt Detroit.vrt
## 	$(CROP) $$(grep -i "Detroit " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm Detroit_1.vrt
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm
## 
GrandCanyonGeneralAviation.tif: GrandCanyonGeneralAviation??.tif
	rm -f $@ GrandCanyonGeneralAviation*.vrt
	$(EXPD) $< GrandCanyonGeneralAviation_1.vrt
	$(WARP) GrandCanyonGeneralAviation_1.vrt GrandCanyonGeneralAviation.vrt
	$(CROP) $$(grep -i "GrandCanyonGeneralAviation " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm GrandCanyonGeneralAviation_1.vrt GrandCanyonGeneralAviation.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm

## HoustonNorth.tif: HoustonNorth*HEL*.tif
## 	rm -f $@ HoustonNorth*.vrt
## 	$(EXPD) $< HoustonNorth_1.vrt
## 	$(WARP) HoustonNorth_1.vrt HoustonNorth.vrt
## 	$(CROP) $$(grep -i "HoustonNorth " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm HoustonNorth_1.vrt HoustonNorth.vrt
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm
## 
## HoustonSouth.tif: HoustonSouth*HEL*.tif
## 	rm -f $@ HoustonSouth*.vrt
## 	$(EXPD) $< HoustonSouth_1.vrt
## 	$(WARP) HoustonSouth_1.vrt HoustonSouth.vrt
## 	$(CROP) $$(grep -i "HoustonSouth " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm HoustonSouth_1.vrt HoustonSouth.vrt
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm
## 
## LosAngelesEast.tif: LosAngelesEast*HEL*.tif
## 	rm -f $@ LosAngelesEast*.vrt
## 	$(EXPD) $< LosAngelesEast_1.vrt
## 	$(WARP) LosAngelesEast_1.vrt LosAngelesEast.vrt
## 	$(CROP) $$(grep -i "LosAngelesEast " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm LosAngelesEast_1.vrt LosAngelesEast.vrt
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm
## 
## LosAngelesWest.tif: LosAngelesWest*HEL*.tif
## 	rm -f $@ LosAngelesWest*.vrt
## 	$(EXPD) $< LosAngelesWest_1.vrt
## 	$(WARP) LosAngelesWest_1.vrt LosAngelesWest.vrt
## 	$(CROP) $$(grep -i "LosAngelesWest " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm LosAngelesWest_1.vrt LosAngelesWest.vrt
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm

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

## OLDER METHOD
## EasternLongIsland.tif: EasternLongIsland*HEL*.tif
## 	rm -f $@ EasternLongIsland*.vrt
## 	$(EXPD) $< EasternLongIsland_1.vrt
## 	$(WARP) EasternLongIsland_1.vrt EasternLongIsland.vrt
## 	$(CROP) $$(grep -i "EasternLongIsland " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@
## 	##&& rm EasternLongIsland_1.vrt EasternLongIsland.vrt
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip  | xargs --no-run-if-empty rm
## 	../../ziptiles.py `../../extract_corners.sh $@` heli meters webp forzip | xargs --no-run-if-empty rm
