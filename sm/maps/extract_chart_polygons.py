#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os.path

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

def PixelsToMeters(px, py, zoom):
    ## "Converts pixel coordinates in given zoom level of pyramid to EPSG:900913"
    res = Resolution( zoom )
    mx = px * res - originShift
    my = py * res - originShift
    return mx, my

def Resolution(zoom):
    ## "Resolution (meters/pixel) for given zoom level (measured at Equator)"
    # return (2 * math.pi * 6378137) / (self.tileSize * 2**zoom)
    return initialResolution / (2**zoom)

def TileBounds(tx, ty, zoom):
    ## "Returns bounds of the given tile in EPSG:900913 coordinates"
    minx, miny = PixelsToMeters( tx*tileSize, ty*tileSize, zoom )
    maxx, maxy = PixelsToMeters( (tx+1)*tileSize, (ty+1)*tileSize, zoom )
    return ( minx, miny, maxx, maxy )

def TileLatLonBounds(tx, ty, zoom ):
    ## "Returns bounds of the given tile in latutude/longitude using WGS84 datum"
    bounds = TileBounds( tx, ty, zoom)
    minLat, minLon = MetersToLatLon(bounds[0], bounds[1])
    maxLat, maxLon = MetersToLatLon(bounds[2], bounds[3])
    return ( minLat, minLon, maxLat, maxLon )

def MetersToLatLon(mx, my ):
    ## "Converts XY point from Spherical Mercator EPSG:900913 to lat/lon in WGS84 Datum"
    lon = (mx / originShift) * 180.0
    lat = (my / originShift) * 180.0
    lat = 180 / math.pi * (2 * math.atan( math.exp( lat * math.pi / 180.0)) - math.pi / 2.0)
    return lat, lon

def main(argv):
    x = float(argv[0])
    y = float(argv[1])
    y, x = MetersToLatLon(x,y)
    print ("%g %g" % (x,y))

if __name__ == "__main__":
    main(sys.argv[1:])
