WARP=gdalwarp -multi -wm 512 -dstnodata 51 -overwrite -of gtiff -t_srs 'EPSG:3857'

IFHEAST = \
/dev/shm/ENR_AKH02_east.tif \
/dev/shm/ENR_P01_east.tif

IFHWEST = \
/dev/shm/ENR_AKH01_west.tif \
/dev/shm/ENR_AKH02_west.tif \
/dev/shm/ENR_H01_west.tif \
/dev/shm/ENR_H02_west.tif \
/dev/shm/ENR_H03_west.tif \
/dev/shm/ENR_H04_west.tif \
/dev/shm/ENR_H05_west.tif \
/dev/shm/ENR_H06_west.tif \
/dev/shm/ENR_H07_west.tif \
/dev/shm/ENR_H08_west.tif \
/dev/shm/ENR_H09_west.tif \
/dev/shm/ENR_H10_west.tif \
/dev/shm/ENR_H11_west.tif \
/dev/shm/ENR_P01_west.tif

VRT = ../../ifr_east.vrt ../../ifr_west.vrt ../../ifh_east.vrt ../../ifh_west.vrt

ALL = $(IFHEAST) $(IFHWEST) $(VRT)

all: $(ALL)

clean:
	rm -f $(ALL) *vrt


/dev/shm/%_west.tif: %.pdf %_west.geojson
	$(eval PDF=$(subst .pdf,.pdf,$<))
	$(eval JSN=$(subst .pdf,_west.geojson,$<))
	rm -f $@ 
	$(WARP) -cutline $(JSN) -crop_to_cutline -r bilinear $(PDF) -tr $(shell ./resolution.sh $<) $@
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters png forzip  | xargs --no-run-if-empty rm
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters webp forzip | xargs --no-run-if-empty rm

/dev/shm/%_east.tif: %.pdf %_east.geojson
	$(eval PDF=$(subst .pdf,.pdf,$<))
	$(eval JSN=$(subst .pdf,_east.geojson,$<))
	rm -f $@ 
	$(WARP) -cutline $(JSN) -crop_to_cutline -r bilinear $(PDF) -tr $(shell ./resolution.sh $<) $@
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters png forzip  | xargs --no-run-if-empty rm
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters webp forzip | xargs --no-run-if-empty rm

/dev/shm/%_west.tif: %.tif %_west.geojson
	$(eval PDF=$(subst .tif,.tif,$<))
	$(eval JSN=$(subst .tif,_west.geojson,$<))
	rm -f $@ 
	$(WARP) $(TRR) $(TRR) -cutline $(JSN) -crop_to_cutline -r lanczos $(PDF) $@
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters png forzip  | xargs --no-run-if-empty rm
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters webp forzip | xargs --no-run-if-empty rm

/dev/shm/%_east.tif: %.tif %_east.geojson
	$(eval PDF=$(subst .tif,.tif,$<))
	$(eval JSN=$(subst .tif,_east.geojson,$<))
	rm -f $@ 
	$(WARP) $(TRR) $(TRR) -cutline $(JSN) -crop_to_cutline -r lanczos $(PDF) $@
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters png forzip  | xargs --no-run-if-empty rm
	../../ziptiles.py `../../extract_corners.sh $@` ifh meters webp forzip | xargs --no-run-if-empty rm

../../ifr_east.vrt: $(IFREAST)
	cd ../../
	gdalbuildvrt -r near -resolution highest -overwrite ifr_east.vrt $(IFREAST)

../../ifr_west.vrt: $(IFRWEST)
	cd ../../
	gdalbuildvrt -r near -resolution highest -overwrite ifr_east.vrt $(IFRWEST)

../../ifh_east.vrt: $(IFHEAST)
	cd ../../
	gdalbuildvrt -r near -resolution highest -overwrite ifr_east.vrt $(IFHEAST)

../../ifh_west.vrt: $(IFHWEST)
	cd ../../
	gdalbuildvrt -r near -resolution highest -overwrite ifr_east.vrt $(IFHWEST)

#rm -f ifh_west.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72.2 -62.7 -5.25 -a_nodata 51 -of vrt merge/${TYPE}/ifh_west.vrt ifh_west.vrt
#rm -f ${TYPE}-east.vrt; gdal_translate -r near -projwin_srs WGS84 -projwin  123.5 62.0 180.0 -5.25 -a_nodata 51 -of vrt merge/${TYPE}/${TYPE}-east.vrt ${TYPE}-east.vrt

