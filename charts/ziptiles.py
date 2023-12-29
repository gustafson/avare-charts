#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os.path

import math

tileSize = 256
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
    ## for myarg in argv:
    ##     print myarg
        
    if (len(argv)!=8):
        print ("ERROR: 8 arguments required")
        for myarg in argv:
            print (myarg)
        sys.exit()

    ## print "length of argv is ", len(argv)
    lon1 = float(argv[0])
    lat1 = float(argv[1])
    lon2 = float(argv[2])
    lat2 = float(argv[3])
    m1 = [lon1, lat1]
    m2 = [lon2, lat2]
    chart = argv[4]
    spec =  argv[5]
    ftype = argv[6]
    maxzoom=14
    
    if spec=="latlon":
        m1 = LatLonToMeters(lat1, lon1)
        m2 = LatLonToMeters(lat2, lon2)

    if chart=="sec":
        chart = 0
        maxzoom=11
    elif chart=="tac":
        chart = 1
        maxzoom=12
    elif chart=="wac":
        chart = 2
        maxzoom=10
    elif chart=="ifr":
        chart = 3
        maxzoom=11
    elif chart=="ifh":
        chart = 4
        maxzoom=10
    elif chart=="ifa":
        chart = 5
        maxzoom=12
    elif chart=="elev":
        chart = 6
        maxzoom=11
    elif chart=="rel":
        chart = 7
        maxzoom=10
    elif chart=="topo":
        chart = 8
        maxzoom=11
    elif chart=="heli":
        chart = 9
        maxzoom=13
    elif chart=="tpc":
        chart = 11
        maxzoom=11
    elif chart=="3dcoarse":
        chart = 13
        maxzoom=13
    elif chart=="3ddetail":
        chart = 14
        maxzoom=13
    elif chart=="elevationdetail":
        chart = 15
        maxzoom=11
## Note delete always chooses pngs because the jpg will just be replaced anyway        
    elif chart=="deletesec":
        chart = 0
    elif chart=="deletetac":
        chart = 1
    elif chart=="deletewac":
        chart = 2
    elif chart=="deleteifr":
        chart = 3
    elif chart=="deleteifh":
        chart = 4
    elif chart=="deleteifa":
        chart = 5
    elif chart=="deleteelev":
        chart = 6
    elif chart=="deleterel":
        chart = 7
    elif chart=="deletetopo":
        chart = 8
    elif chart=="deleteheli":
        chart = 9
    elif chart=="deletetpc":
        chart = 11
    elif chart=="delete3dcoarse":
        chart = 13
    elif chart=="delete3ddetail":
        chart = 14
    elif chart=="deleteelevationdetail":
        chart = 15
    else:
        print ("Chart type not among current list")
        return 1

    ## This is to allow control of tile size within python.  The new
    ## default should be 256.  If were are using 512, then we'll grab
    ## one lower layer.
    if (tileSize==512):
        maxzoom = maxzoom-1

    ## This is due to integer range style in python.  Both this and
    ## the above are both required.
    if (maxzoom<15):
        maxzoom = maxzoom+1

    ## Heli, aren't included in the databases.zip
    if ((argv[7]=="forclean") or (argv[4]=="heli")):
        minzoom = maxzoom-5
    elif (argv[7]=="forzip"):
        minzoom = maxzoom-4
    else:
        sys.exit()

    ## print (f"debug: {ftype} maxzoom {maxzoom} minzoom {minzoom}")
    ## for zoom in range (minzoom,maxzoom):
    for zoom in range (0,maxzoom):
        p1 = MetersToPixels(m1, zoom)
        t1 = PixelsToTile(p1)
        p2 = MetersToPixels(m2, zoom)
        t2 = PixelsToTile(p2)
        mystr2 = "tiles/%i/%i" % (chart, zoom) 
        for i in range (t1[0], t2[0]+1):
            for j in range (t2[1], t1[1]+1):
                mystr3 = "%s/%s" % (i,j)
                fname  = "%s/%s." % (mystr2,mystr3)
                fname += ftype
                ## print (fname)
                if (os.path.isfile(fname)):
                    print (fname)
                if (os.path.isfile("/dev/shm/"+fname)):
                    print ("/dev/shm/"+fname)
                if (os.path.isfile("../../"+fname)):
                    print ("../../"+fname)
        mystr2 = "tiles/%i-build/%i" % (chart, zoom) 
        for i in range (t1[0], t2[0]+1):
            for j in range (t2[1], t1[1]+1):
                mystr3 = "%s/%s" % (i,j)
                fname  = "%s/%s." % (mystr2,mystr3)
                fname += ftype
                if (os.path.isfile(fname)):
                    print (fname)
                if (os.path.isfile("../../"+fname)):
                    print ("../../"+fname)


if __name__ == "__main__":
    main(sys.argv[1:])
