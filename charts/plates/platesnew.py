#!/usr/bin/python



###
import sys
import os.path

def printf(format, *args):
    sys.stdout.write(format % args)

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

def getcornercoords(argv):
    x = float(argv[0])
    y = float(argv[1])
    if (len(argv)>2):
        x1 = float(argv[2])
        y1 = float(argv[3])
        dx = float(argv[4])
        dy = float(argv[5])
        #proc = argv[6]
        #stateloc = proc.find("plates_")
        #state = proc[stateloc+7:stateloc+9]
        #proc=proc.split("/")[-2:]
        y1, x1 = MetersToLatLon(x1,y1)
    y, x = MetersToLatLon(x,y)
    if (len(argv)>2):
        ## THIS FOR ENHANCED DATA INCLUDING STATE ETC
        #printf ("%s|%.5f|%.5f|%.5f|%.5f|||%s|\n" % ("/".join(proc), dx/(x1-x), dy/(y1-y), x, y, state))  # ,x1,y1,(x1-x),(y1-y),
        #printf ("%s|%.5f|%.5f|%.5f|%.5f\n" % ("/".join(proc), dx/(x1-x), dy/(y1-y), x, y))
        return ("%.5f|%.5f|%.5f|%.5f" % (dx/(x1-x), dy/(y1-y), x, y))
    else:
        return ("%.5f %.5f" % (x,y))
        
    #print ("\n#.import file.csv geoplates.db")
        

## if __name__ == "__main__":
##     main(sys.argv[1:])



#import wand
import gdal
import os
import sys

if os.path.exists("charts/plates"):
    os.chdir("charts/plates")

if ((len(sys.argv)) > 2) :
    node = int(sys.argv[1])
    nnodes = int(sys.argv[2])
else:
    node = 0
    nnodes = 1

import glob
xmlfile = glob.glob('./DDTPP/*/d-TPP_Metafile.xml')

import xml.etree.ElementTree as ET

root = ET.parse(xmlfile[-1]).getroot()
cycle = root.attrib['cycle']

## PWD=os.getcwd()
## cpus = 40
## 
## ## A worker function which can be called in parallel
## def worker(pdf):
##     str = ("0 %s %s %s" % (cycle, state, pdf))
##     syscommand = ("./plates.sh %s" % (str))
##     print (syscommand)
##     ### os.system (syscommand)
## 
## ## Note we can eventually use pbs with environment variables
## ## print os.environ['HOME']
## 
## ## This is where the action really happens
## import multiprocessing as mp
## 
## statecount=0;
## for state in root[node::nnodes]:
##     ## If you want just one state for debugging, uncomment the next line
##     if (state.attrib['ID']=="MI"):
##         print ("#" + state.attrib['ID'])
##         statecount += 1;
##         pdfimages, pngimages = copy_files_to_state(state, cycle)
## 
##         state = state.attrib['ID']
##         ## Create a pool of jobs to run in parallel
##         pool = mp.Pool(processes=cpus) #processes=4
## 
##         ## Do all the pdf images in the state
##         pool.map(worker, pdfimages)
##         
##         ## Do only one
##         ## pool.map(worker, [pdfimages[0]])
## 
## ## Create zip files
## print ("./plates.sh 1 %s" % cycle)
## ## Extract database info
## print ("./plates.sh 2 %s" % cycle)
## 
## ## ## Create zip files
## ## os.system ("./plates.sh 1 %s" % cycle)
## ## ## Extract database info
## ## os.system ("./plates.sh 2 %s" % cycle)

def code(r):
    return(r.find("chart_code").text.replace(" ","-"))
def name(r):
    cn = r.find("chart_name").text.replace(" ","-")
    cn = cn.replace("(","").replace(")","").replace("/","-")
    cn = cn.replace("---","-").replace(",","")
    return(cn)
def pdf(r):
    return(r.find("pdf_name").text.replace(" ","-"))
def destdir(r):
    ## return("plates.archive/%s/plates_%s/%s" % (cycle, r[3], r[2]))
    return("plates.archive/%s/plates/%s" % (cycle, r[2]))
def destimg(r):
    return("%s/%s.png" % (destdir(r), r[0]))
    ## return("plates.archive/%s/plates_%s/%s/%s.png" % (cycle, r[3], r[2], r[0]))
def srcdir(r):
    return("DDTPP/%s/%s" % (cycle, r[1]))
def cornerme(r):
    ## Get the strings necessary for writing gps coords as metadata into the png file
    tmp = gdal.Info(gdal.Open(r))
    left = tmp[tmp.find("Corner Coordinates"):].split("\n")[1].split("(")[1].split(")")[0]
    lowerright = [float(s) for s in tmp[tmp.find("Lower Right"):].split("(")[1].split(")")[0].split(",")]
    upperleft  = [float(s) for s in tmp[tmp.find("Upper Left"):].split("(")[1].split(")")[0].split(",")]
    size = [int(s) for s in tmp[tmp.find("Size"):].split("\n")[0][8:].split(",")]
    commenstr = getcornercoords([upperleft[0], upperleft[1], lowerright[0], lowerright[1], size[0], size[1]])
    return(commenstr)

## Get all records that aren't alternate mins
records = [[name(r),pdf(r),airport.attrib['apt_ident'],state.attrib['ID'],code(r)]
           for state in root for city in state for airport in city for r in airport if not code(r)=="MIN"]

from wand.image import Image
import tempfile

def writepng(r):
    ## Make sure the appropriate directory exists
    if not os.path.isdir(destdir(r)):
        os.makedirs (destdir(r))

    ## Work in a temporary directory that gets automagically deleted upon completion
    with tempfile.TemporaryDirectory() as path:
        path += "/"
        tmpfile = path+"tmp.tif"

        ## Deal with hotspots and airport diagrams
        if (r[4] in ["HOT", "APD"]):
            if r[4]=="HOT":
                trim = "-trim +repage"
            else:
                trim = ""

            commstr = "convert -quiet -density 150 -dither none -antialias -depth 8 -quality 00 -background white -alpha remove %s -colors 15 %s -format png8 %s" % (trim, srcdir(r), path+"tmp.png")
            commstr += ("&& optipng -quiet %s" % path+"tmp.png")
            os.system(commstr)
            
        else:
            ## Warp the image
            ds = gdal.Warp(tmpfile, gdal.Open(srcdir(r)), dstSRS='EPSG:3857', height=str(1860), dstAlpha=True, format="GTiff", resampleAlg="lanczos")
            ds = None ## This is needed to ensure it is written
            cornerstr = cornerme(tmpfile)

            ## Write the png image
            with Image(filename=tmpfile) as img:

                img.format="png"
                #img.sharpen(radius=1.0,sigma=2.0)
                img.save(filename=path+"tmp.png")

                ## Reduce the color count
                commstr = "convert -quiet -dither none -antialias  -depth 8 -quality 00 -background white -alpha remove -colors 15 -format png8 %s %s" % (path+"tmp.tif", path+"tmp.png")
                os.system(commstr)

                ## Write avare geotag into file
                commstr='exiftool -overwrite_original_in_place -q -Comment="%s" %s 2> /dev/null && ' % (cornerstr, path+"tmp.png")
                commstr+='exiv2 -M"set Exif.Photo.UserComment charset=Ascii %s" %s' % (cornerstr, path+"tmp.png")
                ## print(commstr)
                os.system(commstr)
            
        ## Finally move it into place
        ## print ("mv %s %s" % (path+"tmp.png", destimg(r)))
        os.system("mv %s %s" % (path+"tmp.png", destimg(r)))

## demo it on Kalamazoo            
rec = [r for r in records if r[2]=="AZO"]
for r in rec:
    writepng(r)

states = list(set([r[3] for r in records]))

for state in states:
    1
    state = "MI"
    
tmp = ["plates/%s/%s.png" % (r[2],r[0]) for r in records if r[3]=="MI" and r[2]=="AZO"]
manifest = "%s\n%s" % (cycle,"\n".join(tmp))

import zipfile
zn = ("%s_PLATES.zip" % state)
zf=zipfile.ZipFile("../final/" + zn, mode='w')
zf.writestr(zn.replace(".zip",""), manifest)
for f in tmp:
    zf.write("plates.archive/%s/%s" %(cycle, f), arcname=f, compresslevel=9)
zf.close()
