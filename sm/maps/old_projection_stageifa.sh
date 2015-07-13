rm -fr merge/IFA; mkdir merge/IFA


# ENR_A01_ATL
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A01_ATL.tif merge/IFA/ENR_A01_ATL.vrt


# ENR_A01_DCA
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A01_DCA.tif merge/IFA/ENR_A01_DCA.vrt


# ENR_A01_DET
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A01_DET.tif merge/IFA/ENR_A01_DET.vrt


# ENR_A01_JAX
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A01_JAX.tif merge/IFA/ENR_A01_JAX.vrt


# ENR_A01_MIA
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A01_MIA.tif merge/IFA/ENR_A01_MIA.vrt


# ENR_A01_MSP
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A01_MSP.tif merge/IFA/ENR_A01_MSP.vrt


# ENR_A01_STL
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A01_STL.tif merge/IFA/ENR_A01_STL.vrt


# ENR_A02_DEN
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A02_DEN.tif merge/IFA/ENR_A02_DEN.vrt


# ENR_A02_DFW
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A02_DFW.tif merge/IFA/ENR_A02_DFW.vrt


# ENR_A02_LAX
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A02_LAX.tif merge/IFA/ENR_A02_LAX.vrt


# ENR_A02_MKC
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A02_MKC.tif merge/IFA/ENR_A02_MKC.vrt


# ENR_A02_ORD
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A02_ORD.tif merge/IFA/ENR_A02_ORD.vrt


# ENR_A02_PHX
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A02_PHX.tif merge/IFA/ENR_A02_PHX.vrt


# ENR_A02_SFO
gdalwarp -of vrt -t_srs 'WGS84'  charts/ifa/ENR_A02_SFO.tif merge/IFA/ENR_A02_SFO.vrt

# Merge all
gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r lanczos -t_srs WGS84 merge/IFA/*.vrt ifa.tif 
## gdalbuildvrt -resolution highest ifa.vrt -overwrite merge/IFA/*.vrt

