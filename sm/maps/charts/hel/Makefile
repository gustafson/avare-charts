EXPD=gdal_translate -of vrt -r cubicspline -a_nodata '0 0 0' -expand rgb 
WARP=gdalwarp -of vrt -r cubicspline -dstnodata '0 0 0' -t_srs 'EPSG:3857'
WAR2=gdalwarp -of gtiff -r cubicspline -dstnodata '0 0 0' -t_srs 'EPSG:3857'
CROP=gdal_translate -of gtiff -r cubicspline -q -projwin_srs WGS84 -projwin

objects := $(patsubst %HEL%.tif,%%.warped.tif,$(wildcard *HEL*tif))

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
# HoustonNorth.tif \
# HoustonSouth.tif \
# USGulfCoast.tif \
# Baltimore.tif \
# Washington.tif \
# LosAngelesEast.tif \
# LosAngelesWest.tif \
# NewYork.tif \

VRT = Houston.vrt USGulfHouston.vrt BaltimoreWashington.vrt LosAngeles.vrt NewYork.vrt

ALL = $(TIF) $(VRT)

heli.vrt: $(ALL)
	gdalbuildvrt -r near -resolution highest $@ -overwrite $^ 

clean:
	rm -f $(ALL) *vrt

%.geojson: %.shp
	ogr2ogr -t_srs EPSG:3857 -segmentize 250 $@ $<

Baltimore.tif: Baltimore*HEL*.tif BaltimoreHEL.geojson
	rm -f $@ Baltimore*.vrt
	$(EXPD) $< Baltimore_1.vrt
	$(WAR2) -cutline BaltimoreHEL.geojson -crop_to_cutline Baltimore_1.vrt Baltimore.tif && rm Baltimore_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

BostonDowntown.tif: BostonDowntown*HEL*.tif
	rm -f $@ BostonDowntown*.vrt
	$(EXPD) $< BostonDowntown_1.vrt
	$(WARP) BostonDowntown_1.vrt BostonDowntown.vrt
	$(CROP) $$(grep -i "BostonDowntown " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm BostonDowntown_1.vrt BostonDowntown.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

Boston.tif: BostonHEL*.tif BostonHEL.geojson
	rm -f $@ Boston*.vrt
	$(EXPD) $< Boston_1.vrt
	$(WAR2) -cutline BostonHEL.geojson -crop_to_cutline Boston_1.vrt Boston.tif && rm Boston_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

Chicago.tif: ChicagoHEL*.tif ChicagoHEL.geojson
	rm -f $@ Chicago*.vrt
	$(EXPD) $< Chicago_1.vrt
	$(WAR2) -cutline ChicagoHEL.geojson -crop_to_cutline Chicago_1.vrt Chicago.tif && rm Chicago_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

ChicagoOHareInset.tif: ChicagoOHareInset*HEL*.tif ChicagoOHareInsetHEL.geojson
	rm -f $@ ChicagoOHareInset*.vrt
	$(EXPD) $< ChicagoOHareInset_1.vrt
	$(WAR2) -cutline ChicagoOHareInsetHEL.geojson -crop_to_cutline ChicagoOHareInset_1.vrt ChicagoOHareInset.tif && rm ChicagoOHareInset_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

Dallas-FtWorth.tif: Dallas-FtWorthHEL*.tif Dallas-FtWorthHEL.geojson
	rm -f $@ Dallas-FtWorth*.vrt
	$(EXPD) $< Dallas-FtWorth_1.vrt
	$(WAR2) -cutline Dallas-FtWorthHEL.geojson -crop_to_cutline Dallas-FtWorth_1.vrt Dallas-FtWorth.tif && rm Dallas-FtWorth_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

Detroit.tif: Detroit*HEL*.tif
	rm -f $@ Detroit*.vrt
	$(EXPD) $< Detroit_1.vrt
	$(WARP) Detroit_1.vrt Detroit.vrt
	$(CROP) $$(grep -i "Detroit " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm Detroit_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

DowntownManhattan.tif: DowntownManhattan*HEL*.tif
	rm -f $@ DowntownManhattan*.vrt
	$(EXPD) $< DowntownManhattan_1.vrt
	$(WARP) DowntownManhattan_1.vrt DowntownManhattan.vrt
	$(CROP) $$(grep -i "DowntownManhattan " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm DowntownManhattan_1.vrt DowntownManhattan.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

EasternLongIsland.tif: EasternLongIsland*HEL*.tif
	rm -f $@ EasternLongIsland*.vrt
	$(EXPD) $< EasternLongIsland_1.vrt
	$(WARP) EasternLongIsland_1.vrt EasternLongIsland.vrt
	$(CROP) $$(grep -i "EasternLongIsland " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm EasternLongIsland_1.vrt EasternLongIsland.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

GrandCanyonGeneralAviation.tif: GrandCanyonGeneralAviation??.tif
	rm -f $@ GrandCanyonGeneralAviation*.vrt
	$(EXPD) $< GrandCanyonGeneralAviation_1.vrt
	$(WARP) GrandCanyonGeneralAviation_1.vrt GrandCanyonGeneralAviation.vrt
	$(CROP) $$(grep -i "GrandCanyonGeneralAviation " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm GrandCanyonGeneralAviation_1.vrt GrandCanyonGeneralAviation.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

HoustonNorth.tif: HoustonNorth*HEL*.tif
	rm -f $@ HoustonNorth*.vrt
	$(EXPD) $< HoustonNorth_1.vrt
	$(WARP) HoustonNorth_1.vrt HoustonNorth.vrt
	$(CROP) $$(grep -i "HoustonNorth " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm HoustonNorth_1.vrt HoustonNorth.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

HoustonSouth.tif: HoustonSouth*HEL*.tif
	rm -f $@ HoustonSouth*.vrt
	$(EXPD) $< HoustonSouth_1.vrt
	$(WARP) HoustonSouth_1.vrt HoustonSouth.vrt
	$(CROP) $$(grep -i "HoustonSouth " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm HoustonSouth_1.vrt HoustonSouth.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

LosAngelesEast.tif: LosAngelesEast*HEL*.tif
	rm -f $@ LosAngelesEast*.vrt
	$(EXPD) $< LosAngelesEast_1.vrt
	$(WARP) LosAngelesEast_1.vrt LosAngelesEast.vrt
	$(CROP) $$(grep -i "LosAngelesEast " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm LosAngelesEast_1.vrt LosAngelesEast.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

LosAngelesWest.tif: LosAngelesWest*HEL*.tif
	rm -f $@ LosAngelesWest*.vrt
	$(EXPD) $< LosAngelesWest_1.vrt
	$(WARP) LosAngelesWest_1.vrt LosAngelesWest.vrt
	$(CROP) $$(grep -i "LosAngelesWest " HeliBounds.txt |cut -d" " -f2-) $(patsubst %.tif,%.vrt,$@) $@ && rm LosAngelesWest_1.vrt LosAngelesWest.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

NewYork.tif: NewYorkHEL*.tif NewYorkHEL.geojson
	rm -f $@ NewYork*.vrt
	$(EXPD) $< NewYork_1.vrt
	$(WAR2) -cutline NewYorkHEL.geojson -crop_to_cutline NewYork_1.vrt NewYork.tif && rm NewYork_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

USGulfCoast.tif: USGulfCoastHEL*.tif USGulfCoastHEL.geojson
	rm -f $@ USGulfCoast*.vrt
	$(EXPD) $< USGulfCoast_1.vrt
	$(WAR2) -cutline USGulfCoastHEL.geojson -crop_to_cutline USGulfCoast_1.vrt USGulfCoast.tif && rm USGulfCoast_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

Washington.tif: WashingtonHEL*.tif WashingtonHEL.geojson
	rm -f $@ Washington*.vrt
	$(EXPD) $< Washington_1.vrt
	$(WAR2) -cutline WashingtonHEL.geojson -crop_to_cutline Washington_1.vrt Washington.tif && rm Washington_1.vrt
	../../ziptiles.py `../../extract_corners.sh $@` heli meters png forzip | xargs rm

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

