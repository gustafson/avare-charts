#!/usr/bin/env python2

#Copyright (c) 2012, Zubair Khan (governer@gmail.com)
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


from mapnik import *
import math
import urllib
import sys

if len(sys.argv) < 4:
	print "run as " + str(sys.argv[0]) + " airportid lon_center lat_center"
	sys.exit()

latc = float(sys.argv[3])
lonc = float(sys.argv[2])
airport = sys.argv[1]

x = 1664
y = 1664
mapfile = 'mapnik_style.xml'
map_output = 'Streets.png'

width = 0.01 / math.cos(latc / 57.3)
height = 0.01

latu=latc + height
latd=latc - height
lonl=lonc - width
lonr=lonc + width
latdiff = latd - latu
londiff = lonr - lonl
dx = x / londiff
dy = y / latdiff

# Download are of our airport
url = "http://overpass-api.de/api/map?bbox=" + str(lonl) + "," + str(latd) + "," + str(lonr) + "," + str(latu)
#urllib.urlretrieve (url, "map.osm")

m = Map(x,y)
load_map(m, mapfile)

bbox=(Envelope(lonc - width, latc + height, lonc + width, latc - height))

m.zoom_to_box(bbox)

render_to_file(m, map_output,'png8:z=9:t=0')

out = airport + "/" + map_output + "," + str(dx) + "," + str(dy) + "," + str(lonl) + "," + str(latu) + "\n"
sys.stdout.write(out)

