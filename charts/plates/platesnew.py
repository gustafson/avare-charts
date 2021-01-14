#!/usr/bin/python

import gdal
import os
import sys
from wand.image import Image, Color
import tempfile
import math
import glob
import xml.etree.ElementTree as ET

## Image target size (approximate due to trimming)
size = 1860

def printf(format, *args):
    sys.stdout.write(format % args)

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
        y1, x1 = MetersToLatLon(x1,y1)
    y, x = MetersToLatLon(x,y)
    if (len(argv)>2):
        return ("%.5f|%.5f|%.5f|%.5f" % (dx/(x1-x), dy/(y1-y), x, y))
    else:
        return ("%.5f %.5f" % (x,y))

################################################

## This overcomes an emacs quirk and is meaningless if not using emacs
if os.path.exists("charts/plates"):
    os.chdir("charts/plates")

## Code which may allow splitting to different machines in the future
if ((len(sys.argv)) > 2) :
    node = int(sys.argv[1])
    nnodes = int(sys.argv[2])
else:
    node = 0
    nnodes = 1

##
xmlfile = glob.glob('./DDTPP/*/d-TPP_Metafile.xml')
root = ET.parse(xmlfile[-1]).getroot()
cycle = root.attrib['cycle']

PWD=os.getcwd()
cpus = 16

## Utility functions for working on records
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
    return("plates.archive/%s/plates/%s" % (cycle, r[2]))

def destimg(r):
    return("%s/%s.png" % (destdir(r), r[0]))
    ## return("plates.archive/%s/plates_%s/%s/%s.png" % (cycle, r[3], r[2], r[0]))

def srcimg(r):
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

def nowarp(pdf, out, trim=True):
    with Image(filename=pdf,resolution=150) as pdf:

        pages = len(pdf.sequence)
        height=0
        width=0
        for j in range(pages):
            ## Go through the sequence and trim them individually
            with pdf.sequence.index_context(j):
                pdf.trim()
                height+=pdf.height+10
                if (width<pdf.width):
                    width=pdf.width

        i = Image(
            width=width,
            height=height
        )

        height = [r.height for r in pdf.sequence]
        height = height[::-1]
        height.append(0)
        height = height[::-1]
        width = [math.floor((width-r.width)/2) for r in pdf.sequence]

        for j in range(pages):
            i.composite(
                pdf.sequence[j],
                top=height[j]+j*10,
                left=width[j]
            )
        i.background_color = Color('white') # Set white background.
        i.alpha_channel = 'remove'
        if trim:
            i.trim()
        i.sharpen(radius=5.0,sigma=5.0)
        i.posterize(16,"no")
        i.normalize()
        i.compression_quality=00
        i.save(filename=out.replace(".png",".png8"))
        tmp = out.replace(".png","")+"*"
        out = glob.glob(tmp)
        if (os.system("rename .png8 .png %s*" % tmp)):
            print("Error in saving file.")
        if (os.system("optipng -quiet %s*" % tmp)):
            print("Error in optipng.")

def gettrims(tmpfile):
    with Image(filename=tmpfile) as img:
        img.format = 'png'
        img.background_color = Color('white') # Set white background.
        img.alpha_channel = 'remove' 
        img.trim()
        ## -format "%X %Y %w %h" info:
        ## comes back as something like +17 +95 1180 1728
        return([img.page_x,img.page_y,img.width,img.height])

def worker(r):
    try:
        writepng(r)
    except:
        print("error on record: ", record)

DEBUG=0
### This is the big utility function where all the action happends
def writepng(r):
    ## Note the destination directories must already exist!

    ## If the image or images already exists, assume it is good and skip it
    ## if (os.path.isfile(destimg(r))):
    if (len(glob.glob(destimg(r).replace(".png","*.png")))>0):
        ## print("file exists: %s" % destimg(r))
        return (None)

    ## Work in a temporary directory that gets automagically deleted upon completion
    with tempfile.TemporaryDirectory() as path:
        path += "/"
        srcfile = gdal.Open(srcimg(r))

        if DEBUG:
            print (srcfile)

        ## Check if the source file has a gdal projection
        noproj = gdal.Info(srcfile)
        noproj = (noproj.find("PROJCRS") < 0)
        
        ## Deal with hotspots and airport diagrams etc.  This is everything but plates
        ## if (r[4] in ["APD", "DAU", "DP", "HOT", "LAH", "ODP", "STAR"] or noproj):
        if (noproj):
            if DEBUG:
                print ("No projection")

            if r[4]=="APD": ## Airport directories aren't trimmed for now
                #trim = ""
                trim = False
            else:
                #trim = "-trim +repage"
                trim = True

            nowarp(srcimg(r), path+r[0]+".png", trim=trim)

            ## commstr = "convert -quiet -density 150 -dither none -antialias -depth 8 -quality 00 -background white -alpha remove %s -colors 15 %s -format png8 %s" % (trim, srcimg(r), path+r[0]+".png")
            ## commstr += ("&& optipng -quiet %s" % path+r[0]+"*.png")
            ## if (os.system(commstr)):
            ##     print ("Failed noproj image conversion")
            ## if DEBUG:
            ##     print (commstr)
            
        else:
            tmpfile1 = path+"tmp1.tif"
            tmpfile2 = path+"tmp.tif"

            ## Warp the image
            ds = gdal.Warp(tmpfile1, srcfile, dstSRS='EPSG:3857',
                           height=str(size), dstAlpha=True, format="GTiff", resampleAlg="lanczos")
            ds = None ## This is needed to ensure it is written
            ds = gdal.Translate(tmpfile2,gdal.Open(tmpfile1),srcWin=gettrims(tmpfile1))
            ds = None

            ## Get the corner strings for the geotag
            cornerstr = cornerme(tmpfile2)

            ## Write the png image
            with Image(filename=tmpfile2) as img:

                img.sharpen(radius=5.0,sigma=5.0)
                img.background_color = Color('white') # Set white background.
                img.alpha_channel = 'remove' 
                img.posterize(16,"no")
                extension = "png8"
                img.format=extension
                img.normalize()
                img.save(filename=path+r[0]+extension)

                ## Write avare geotag into file.  Suppress the warning
                if (extension=="png8"):
                    commstr=("mv %s %s" % (path+r[0]+extension, path+r[0]+".png &&"))
                else:
                    commstr=""
                commstr+='exiftool -overwrite_original_in_place -q -Comment="%s" %s 2> /dev/null && ' % (cornerstr, path+r[0]+".png")
                commstr+='exiv2 -M"set Exif.Photo.UserComment charset=Ascii %s" %s' % (cornerstr, path+r[0]+".png")
                if (os.system(commstr)):
                    print("Failed at exif writing %s %s %s %s" % (r))
                if DEBUG:
                    print (commstr)

        ## Finally move the resulting file(*) into place
        commstr = "mv %s %s" % (path+r[0]+"*.png", destdir(r)+"/")
        if os.system(commstr):
            print("Move failed for " + path+r[0]+"*.png")
        if DEBUG:
            print (commstr)
        import time

## Get all records that aren't alternate mins which are managed by separate code within Avare and chart prep
records = [[name(r),pdf(r),airport.attrib['apt_ident'],state.attrib['ID'],code(r)]
           for state in root for city in state for airport in city for r in airport
           if (not code(r)=="MIN") and (not pdf(r)=="DELETED_JOB.PDF")]

## demo it on Kalamazoo or MI
## records = [r for r in records if r[3]=="MI"] # if r[2]=="AZO" and 

## Make sure all the appropriate directories exist.
## The prevents directory creation collisions in multiprocessing
for r in records:
    if not os.path.isdir(destdir(r)):
        os.makedirs (destdir(r))

## Create the state list
states = list(set([r[3] for r in records]))

## Divide the states by machine
states = states[node::nnodes]
records = [r for r in records if r[3] in states]
print("%s states and %s records to be processed on this node" % (len(states),len(records)))
print(states)

## Run the jobs in parallel
import multiprocessing as mp
## Create a pool of jobs to run in parallel

## Bookkeeping to estimate time remaining... not great.
count = []
total = len(records)
with mp.Pool(processes=cpus) as pool:
    # pool.map(worker, records)
    for instance in pool.imap_unordered(worker, records):
        count.append(instance)
        if (len(count)%100==0):
            print ("Approximately %2.2f%% complete" % (100*len(count)/total))

#worker(records[0])

def zipit(state):
     print("Zipping %s" % state)
 
     ## Must deal with multiple images per record.  Grab all at each airport
     tmp = [glob.glob("plates.archive/%s/plates/%s/*" % (cycle,r[2])) for r in records if r[3]==state]
 
     ## Flattent the list
     tmp = [i for sub in tmp for i in sub]
 
     ## Remove duplicate airports
     tmp = list(set(tmp))
 
     ## Create manifest string
     manifest = "%s\n%s" % (cycle,"\n".join(tmp))
 
     ## Do the zipping
     import zipfile
     zn = ("%s_PLATES.zip" % state)
     zf=zipfile.ZipFile("../final/" + zn, mode='w')
     zf.writestr(zn.replace(".zip",""), manifest)
     for f in tmp:
         zf.write(f, arcname=f.replace("plates.archive/%s/" %(cycle),""), compresslevel=9)
     zf.close()
     print("Zipping %s complete" % state)

states.sort()
## for state in states:
##     zipit(state)

count = []
total = len(states)
with mp.Pool(processes=cpus) as pool:
    for instance in pool.imap_unordered(zipit, states):
        count.append(instance)
        if (len(count)%100==0):
            print ("Approximately %2.2f%% complete" % (100*len(count)/total))
