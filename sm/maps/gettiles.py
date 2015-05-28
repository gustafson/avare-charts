#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os.path
## ## import getopt
## ## from gdal2tiles_512_mysingle import *
## # norm = 2
## from gdal2tiles import *
## # norm = 1
## ## print 'Number of arguments:', len(sys.argv), 'arguments.'
## ## print 'Argument List:', str(sys.argv)
## 
## def main(argv):
##     if len(argv)>2:
##         #tmp =  GlobalGeodetic(GlobalMercator()).LonLatToTile(float(argv[0]),float(argv[1]),int(argv[4]))
## #        tmp += GlobalGeodetic(GlobalMercator()).LonLatToTile(float(argv[2]),float(argv[3]),int(argv[4]))
## #        tmp =  GlobalGeodetic(GlobalMercator()).LonLatToTile(float(argv[2]),float(argv[3]),int(argv[4]))
## #        tmp += GlobalGeodetic(GlobalMercator()).LonLatToTile(float(argv[0]),float(argv[1]),int(argv[4]))
## #        mystr1 = "#%i,%i,%i,%i " % tmp
## #        mystr2 = "tiles/%s/sec/all/" % argv[5]
## #        mystr2 += argv[4]
## #        for i in range (tmp[0], tmp[2]):
## #            for j in range (tmp[3], tmp[1]):
## #                mystr3 = "%s/%s" % (i,j)
## #                print "%s/%s.png" % (mystr2,mystr3)
##         # print "%g %g" % (float(argv[0]),float(argv[1]))
##         # print "%g %g" % GlobalMercator().LatLonToMeters(float(argv[0]),float(argv[1]))
##         gm = GlobalGeodetic()
##         tmp = gm.LonLatToTile(float(argv[0]),float(argv[1]),int(argv[4]))
##         print "%g %g %g %g" % gm.TileBounds(tmp[0],tmp[1],int(argv[4]))
##         print "%g %g" % gm.LonLatToPixels(tmp[0],tmp[1],int(argv[4]))
##         print "%g %g" % tmp
##         ## print "%g %g %g %g" % gm.TileLatLonBounds(tmp[0],tmp[1],int(argv[4]))
##         print "%g" % gm.Resolution(int(argv[4]))
##         
## if __name__ == "__main__":
##     main(sys.argv[1:])
## 
## 
## 
## 
## 

import math
tileSize = 512
originShift = 2 * math.pi * 6378137.0 / 2.0
initialResolution = 20037508.342789244 * 2.0 / tileSize

def LatLonToMeters(lat, lon):
    ## "Converts given lat/lon in WGS84 Datum to XY in Spherical Mercator EPSG:900913"
    mx = lon * originShift / 180.0
    my = math.log(math.tan((90.0 + lat) * math.pi / 360.0 )) / (math.pi / 180.0)
    my = my * originShift / 180.0
    return [mx,my]
    
def MetersToPixels(m,zoom):
    mx=m[0]
    my=m[1]
    ## "Converts EPSG:900913 to pyramid pixel coordinates in given zoom level"
    res = initialResolution / (2.0**zoom)
    px = (mx + originShift) / res
    py = (my + originShift) / res
    return [px,py]
    
def PixelsToTile(p):
    px = p[0]
    py = p[1]
    ## "Returns a tile covering region in given pixel coordinates"
    tx = (int)(math.ceil(px / (float)(tileSize)) - 1)
    ty = (int)(math.ceil(py / (float)(tileSize)) - 1)
    return [tx,ty]

def main(argv):
    lon1 = float(argv[0])
    lat1 = float(argv[1])
    lon2 = float(argv[2])
    lat2 = float(argv[3])
    cycle = argv[4]
    chart = argv[5][7:10]
    img = argv[6]
    for zoom in range (0,12):
        m1 = LatLonToMeters(lat1, lon1)
        p1 = MetersToPixels(m1, zoom)
        t1 = PixelsToTile(p1)
        m2 = LatLonToMeters(lat2, lon2)
        p2 = MetersToPixels(m2, zoom)
        t2 = PixelsToTile(p2)
        mystr2 = "tiles/%s/" % cycle + chart + "/all/%i" % zoom 
        ## print "%i %i %i" % (zoom, t1[0], t2[0])
        ## print "%i %i %i" % (zoom, t2[1], t1[1])
        for i in range (t1[0], t2[0]+1):
            for j in range (t2[1], t1[1]+1):
                mystr3 = "%s/%s" % (i,j)
                fname = "%s/%s." % (mystr2,mystr3)
                fname += img
                if (os.path.isfile(fname)):
                    print fname

if __name__ == "__main__":
    main(sys.argv[1:])
