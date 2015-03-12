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

# Need mapnik import of dev in Ubuntu, install from synaptic
from mapnik import *
import sqlite3 as lite
import math
import urllib
import sys
import shutil

def todb(values,proc):
	try:
	    con = lite.connect('geoplates.db')

	    cur = con.cursor()  

	    script = "CREATE TABLE IF NOT EXISTS geoplates(proc varchar(128), dx float, dy float, lon float, lat float);" 
	    script += "DELETE FROM geoplates where proc='" + proc + "';";
	    script += "INSERT INTO geoplates VALUES(" + values + ");";

	    cur.executescript(script)

	    con.commit()
	    
	except lite.Error, e:
	    
	    if con:
		con.rollback()
		
	    print "Error %s:" % e.args[0]
	    sys.exit(1)
	    
	finally:
	    
	    if con:
		con.close() 


def do_one(airport,lonc,latc):

	# max size we can support
	x = 1664
	y = 1664
	mapfile = 'mapnik_style.xml'
	map_output = 'AREA.png'

	width = 0.015 / math.cos(latc / 57.3)
	height = 0.015

	# plates calculations
	latu=latc + height
	latd=latc - height
	lonl=lonc - width
	lonr=lonc + width
	latdiff = latd - latu
	londiff = lonr - lonl
	dx = x / londiff
	dy = y / latdiff

	#OSM projection
	inproj = Projection('+init=epsg:4326')
	#Map projection
	outproj = Projection('+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_def  +over')

	# Download area of our airport
	if not os.path.exists(airport + ".osm"):
	    url = "http://overpass-api.de/api/map?bbox=" + str(lonl) + "," + str(latd) + "," + str(lonr) + "," + str(latu)
	    urllib.urlretrieve (url, airport + ".osm")
        
	# Prepare to create
	shutil.copyfile(airport + ".osm", "map.osm")

	m = Map(x,y)
	load_map(m, mapfile)

	# projection
	m.srs = outproj.params()

	# bounded by
	bbox=(Envelope(lonc - width, latc + height, lonc + width, latc - height))

	# our bound must be transformed
	transform = ProjTransform(inproj,outproj)

	m.zoom_to_box(transform.forward(bbox))

	# Store in plates folder
	if not os.path.exists("plates"):
	    os.makedirs("plates")

	if not os.path.exists("plates/" + airport):
	    os.makedirs("plates/" + airport)

    	# render the map to an image
    	im = Image(x,y)
    	render(m, im)
    	im.save("plates/" + airport + "/" + map_output,'png8:z=9:t=0')

	# This for database
	out = "'" + airport + "/" + map_output + "','" + str(dx) + "','" + str(dy) + "','" + str(lonl) + "','" + str(latu) + "'"
	todb(out,airport + "/" + map_output)

	# Show done
	print airport + " done" 

# Main
do_one(str(sys.argv[1]),float(sys.argv[2]),float(sys.argv[3]))

