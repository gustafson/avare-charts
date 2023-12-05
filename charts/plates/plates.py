#!/usr/bin/python

# Copyright (c) 2021, Peter A. Gustafson (pgustafson@gmail.com)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

from osgeo import gdal
import os
import sys
from wand.image import Image, Color
from wand import drawing
import tempfile
import math
import glob
import xml.etree.ElementTree as ET
import multiprocessing as mp

## PDF is 594 pts tall (72DPI is default)
## Image target size
size = 1900
pdfDense = (size/594)*72
#resampling="lanczos"
resampling="bilinear" ## Good enough when downsampling from pdf

CHOOSERES=["lowres","highres"]
CHOOSERES=["lowres"]


### The following code is slightly modified from gdal for our purpose
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

def getCornerCoords(argv):
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

## This overcomes an emacs quirk with working directories on my
## machine and should be meaningless if not using emacs
if os.path.exists("charts/plates"):
    os.chdir("charts/plates")

## Code which may allow splitting work to different machines
if ((len(sys.argv)) > 3) :
    node = int(sys.argv[1])
    nnodes = int(sys.argv[2])
    cpus = int(sys.argv[3])
else:
    node = 0
    nnodes = 1
    cpus = mp.cpu_count()

##
xmlfile = glob.glob('./DDTPP/*/d-TPP_Metafile.xml')
print(f'Evaluating {xmlfile}')
root = ET.parse(xmlfile[-1]).getroot()
cycle = root.attrib['cycle']
print(f'Found cycle {cycle}')

## Utility functions for working on records
def runwayID(r):
    return(r[0])

def recordAirportID(r):
    return(r[2])

def recordState(r):
    return(r[3])

def recordType(r):
    return(r[4])

def recordCode(r):
    return(r.find("chart_code").text.replace(" ","-"))

def recordName(r):
    cn = r.find("chart_name").text.replace(" ","-")
    cn = cn.replace("(","").replace(")","").replace("/","-")
    cn = cn.replace("---","-").replace(",","")
    return(cn)

def pdfFileName(r):
    return(r.find("pdf_name").text.replace(" ","-"))

def destDir(r, base="lowres"):
    return("plates.archive/%s/%s/plates/%s" % (cycle, base, recordAirportID(r)))

def destImg(r, base="lowres"):
    return("%s/%s.png" % (destDir(r,base), runwayID(r)))
    ## return("plates.archive/%s/plates_%s/%s/%s.png" % (cycle, recordState(r), recordAirportID(r), runwayID(r)))

def srcImg(r):
    return("DDTPP/%s/%s" % (cycle, r[1]))

def getTagCoordinates(r):
    ## Get the strings necessary for writing gps coords as metadata into the png file
    tmp = gdal.Info(gdal.Open(r))
    left = tmp[tmp.find("Corner Coordinates"):].split("\n")[1].split("(")[1].split(")")[0]
    lowerright = [float(s) for s in tmp[tmp.find("Lower Right"):].split("(")[1].split(")")[0].split(",")]
    upperleft  = [float(s) for s in tmp[tmp.find("Upper Left"):].split("(")[1].split(")")[0].split(",")]
    size = [int(s) for s in tmp[tmp.find("Size"):].split("\n")[0][8:].split(",")]
    commenstr = getCornerCoords([upperleft[0], upperleft[1], lowerright[0], lowerright[1], size[0], size[1]])
    return(commenstr)

def tmpDest(path,r,p):
        thedest = ("%s/%s" % (path,p))
        if not os.path.isdir(thedest):
            os.makedirs (thedest)
        thedest = ("%s/%s" % (thedest,runwayID(r)+".png"))
        return(thedest)

def writeImageNoWarp(pdf, out, resolution=pdfDense, trim=True, warn=False):
    with Image(filename=pdf, resolution=resolution) as pdf:

        pages = len(pdf.sequence)
        height=0
        width=0
        for j in range(pages):
            ## Go through the sequence and trim them individually
            with pdf.sequence.index_context(j):
                if trim:
                    pdf.trim()
                    height+=pdf.height+10
                    if (width<pdf.width):
                        width=pdf.width
                else:
                    width=pdf.width
                    height=pdf.height

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
        if trim: ## This is necessary because of stacked charts (above)
            i.trim()
        i.sharpen(radius=5.0,sigma=5.0)
        i.normalize()
        i.quantize(16, dither=False)
        i.compression_quality=00
        
        if warn: # This is intended for plates that do not have proper GPS tags.  One found in 2305
            with drawing.Drawing() as ctx:
                ctx.fill_color = Color('RED')
                ctx.font_family = 'Times New Roman, Nimbus Roman No9'
                ctx.text_decoration = 'underline'
                ctx.text_kerning = -1
                ctx.gravity = 'center'
                h = i.height
                w = i.width
                ctx.font_size = 0.018947368421052633*h
                warnstr = 'Warning: no Avare GPS tag'
                i.annotate(warnstr, ctx, left=0,      baseline=-h*.480, angle=0)
                i.annotate(warnstr, ctx, left=-w*.48, baseline=-h*.300, angle=90)
                i.annotate(warnstr, ctx, left=-w*.48, baseline=+h*.300, angle=90)
                i.annotate(warnstr, ctx, left=+w*.48, baseline=-h*.300, angle=270)
                i.annotate(warnstr, ctx, left=+w*.48, baseline=+h*.300, angle=270)
                i.annotate(warnstr, ctx, left=0,      baseline=+h*.485, angle=0)
                
        i.save(filename=out.replace(".png",".png8"))
        tmp = out.replace(".png","")+"*"
        #out = glob.glob(tmp)
        if (os.system("rename .png8 .png %s*" % tmp)):
            print("Error in saving file.")
        if (os.system("optipng -quiet %s*" % tmp)):
            print("Error in optipng.")
        commstr='cwebp -quiet -lossless -z 9 -metadata exif %s -o %s' % (out, out.replace(".png",".webp"))
        if (os.system(commstr)):
            print("Error in cwebp")

def getTrims(tmpfile):
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
        ## Density must be passed so that it is a local variable
        ProcessRecord(r, pdfDense=pdfDense)
    except:
        print("error on record: ", record)

DEBUG=0
### This is the big utility function where all the action happends
def ProcessRecord(r, pdfDense=None):
    if not pdfDense:
        print ("ERROR: pdfDense must be passed so that it is local to a multiprocessing thread.")
    
    ## Note the destination directories must already exist!

    ## If the image exists, assume it is good and skip it
    ## if (os.path.isfile(destImg(r, base="lowres"))) and (os.path.isfile(destImg(r, base="highres"))):
    if all([os.path.isfile(destImg(r, base=res)) for res in CHOOSERES]):
        return (None)

    ## Work in a temporary directory that gets automagically deleted upon completion
    with tempfile.TemporaryDirectory() as path:

        ## path="/dev/shm"
        srcfile = gdal.Open(srcImg(r))

        if DEBUG:
            print (srcfile)

        ## Check if the source file has a gdal projection
        noproj = gdal.Info(srcfile)
        noproj = (noproj.find("PROJCRS") < 0)
        
        ## Deal with hotspots and airport diagrams etc.  This is everything but plates
        ## if (recordType(r) in ["APD", "DAU", "DP", "HOT", "LAH", "ODP", "STAR"] or noproj):
        if (noproj):
            if DEBUG:
                print ("No projection")

            if recordType(r)=="APD": ## Airport directories aren't trimmed for now
                trim = False
                pdfDense = 150 ## Temporary until such time as airport directory database can be updated.
            else:
                trim = True # -trim +repage

            for p in CHOOSERES:
                thedense = pdfDense if p=="lowres" else pdfDense*2
                writeImageNoWarp(srcImg(r), tmpDest(path,r,p), resolution = thedense, trim=trim)

        else:
            
            highDensityTmp = path+"/highDensityTmp.tif"
            extension = "png8"

            ## Warp the image to high density. Do at least at 2x because high res is at 2x
            commstr = "gdalwarp -r %s -q -dstalpha --config GDAL_PDF_DPI %s -t_srs EPSG:3857 %s %s" % (resampling, pdfDense*2, srcImg(r), highDensityTmp)
            try:
                os.system(commstr)
           
                for p in CHOOSERES:
                    thedest = tmpDest(path,r,p)
                    thesize = size if p=="lowres" else size*2
                    ds = gdal.Translate(thedest,gdal.Open(highDensityTmp),
                                        resampleAlg=resampling, srcWin=getTrims(highDensityTmp),
                                        height=thesize, width=0, scaleParams=[[]])
                    ds = None

                    ## Get the corner strings for the geotag
                    cornerstr = getTagCoordinates(thedest)

                    ## Write the png image
                    with Image(filename=thedest) as img:

                        #img.sharpen(radius=5.0,sigma=5.0)
                        img.background_color = Color('white') # Set white background.
                        img.alpha_channel = 'remove' 
                        img.format=extension
                        img.normalize()
                        img.quantize(16, dither=False)
                        # img.type = 'palette'
                        img.save(filename=thedest+"."+extension)

                        ## Write avare geotag into file.  Suppress the warning
                        if (extension=="png8"):
                            commstr=("mv %s %s" % (thedest+"."+extension, thedest))
                        else:
                            commstr="echo -n"
                        commstr+=' && optipng -quiet %s' % (thedest)
                        commstr+=' && exiftool -overwrite_original_in_place -q -Comment="%s" %s 2> /dev/null ' % (cornerstr, thedest)
                        commstr+=' && exiv2 -M"set Exif.Photo.UserComment charset=Ascii %s" %s' % (cornerstr, thedest)
                        ## commstr+=' && identify %s' % (thedest)
                        commstr+=' && cwebp -quiet -lossless -z 9 -metadata exif %s -o %s' % (thedest, thedest.replace(".png",".webp"))
                        ## commstr+=' && identify %s' % (thedest)
                        if (os.system(commstr)):
                            print("Failed at exif writing %s %s %s %s" % (r))
                        if DEBUG:
                            print (commstr)

            except:
                print("Failed warping didn't work")
                print(commstr)

                ## Fall back to non-gps tagged
                for p in CHOOSERES:
                    os.system('touch %s' % tmpDest(path,r,p).replace(".png",".webp.broken"))
                    os.system("mv %s %s" % (tmpDest(path,r,p).replace(".png",".webp.broken"), destDir(r,base=p)+"/"))

                    ## From here the treatment is the same as airport diagram above
                    thedense = pdfDense if p=="lowres" else pdfDense*2
                    thedest = tmpDest(path,r,p)
                    writeImageNoWarp(srcImg(r), thedest, resolution = thedense, trim=False, warn=True)
                    commstr=f'cwebp -quiet -lossless -z 9 -metadata exif %s -o %s' % (thedest, thedest.replace(".png",".webp"))
                    os.system(commstr)
                            
        ## Finally move the resulting file(*) into place
        for p in CHOOSERES:
            commstr = "mv %s %s" % (tmpDest(path,r,p), destDir(r,base=p)+"/")
            commstr += " && mv %s %s" % (tmpDest(path,r,p).replace(".png",".webp"), destDir(r,base=p)+"/")
            if os.system(commstr):
                print("Move failed for " + path+runwayID(r)+"*.png")
                if DEBUG:
                    print (commstr)

def balanceLoadByState(lengths):
    ## Divide the work of the states so that there is approximately
    ## the same number of records done on each machine
    
    import numpy
    def findLowestNode(l):
        if any([i == [] for i in l]):
            return([i==[] for i in l].index(True))
        else:
            l = [sum(i) for i in l]
            return(numpy.argsort(l)[0])

    block = {"States": [], "Records": []}
    blocks = []
    import copy
    for i in range(nnodes):
        new = copy.deepcopy(block)
        blocks.append(new)

    for i in range(len(lengths)):
        j = findLowestNode([b["Records"] for b in blocks])
        blocks[j]["States"].append(lengths[i][1])
        blocks[j]["Records"].append(lengths[i][0])
    return(blocks)

## Get all records that aren't alternate mins which are managed by separate code within Avare and chart prep
records = [[recordName(r),pdfFileName(r),airport.attrib['apt_ident'],state.attrib['ID'],recordCode(r)]
           for state in root for city in state for airport in city for r in airport
           if (not recordCode(r)=="MIN") and (not pdfFileName(r)=="DELETED_JOB.PDF")]

## demo it on Kalamazoo or MI
## records = [r for r in records if recordState(r)=="MI" and recordAirportID(r)=="AZO"] # if recordAirportID(r)=="AZO" and 
## print(records)

## Create the state list
states = list(set([recordState(r) for r in records]))

## Divide the states by machine
lengths = [[len([r for r in records if recordState(r) == s]),s] for s in states]
lengths.sort(reverse=True)

## Choose states
states = balanceLoadByState(lengths)[node]["States"]
states.sort()
records = [r for r in records if recordState(r) in states]

print("%s states and %s records to be processed on this node" % (len(states),len(records)))
print(states)

## Make final directory.  Do it here otherwise there have been
## conflicts in multiprocessing.
for p in CHOOSERES:
    if not os.path.isdir("../final-%s" % p):
        os.makedirs ("../final-%s" % p)

## Make sure all the appropriate directories exist.
## The prevents directory creation collisions in multiprocessing
for r in records:
    for p in CHOOSERES:
        if not os.path.isdir(destDir(r, base=p)):
            os.makedirs (destDir(r, base=p))

## Run the jobs in parallel
## Create a pool of jobs to run in parallel
## Bookkeeping to estimate completion
count = []
total = len(records)
with mp.Pool(processes=cpus) as pool:
    # pool.map(worker, records)
    for instance in pool.imap_unordered(worker, records):
        count.append(instance)
        if (len(count)%100==0):
            print ("Approximately %2.2f%% complete" % (100*len(count)/total))
#records[33]
#worker(records[33])

def ZipStateTiles(state):
     print("Zipping %s" % state)

     for p in CHOOSERES:
         ## Must deal with multiple images per record.  Grab all at each airport
         tmp = [glob.glob("plates.archive/%s/%s/plates/%s/*png"
                          % (cycle,p,recordAirportID(r)))
                for r in records if recordState(r)==state]

         ## Flattent the list
         tmp = [i for sub in tmp for i in sub]

         ## Remove duplicate airports
         tmp = list(set(tmp))

         ## Create manifest string
         manifest = "%s\n%s" % (cycle,"\n".join(tmp))

         ## Do the zipping
         import zipfile
         zn = ("%s_PLATES.zip" % state)
         zf=zipfile.ZipFile("../final-%s/%s" % (p, zn), mode='w')

         ## Write the manifest
         zf.writestr(zn.replace(".zip",""), manifest.replace("plates.archive/%s/%s/" %(cycle,p),""))

         for f in tmp:
             zf.write(f, arcname=f.replace("plates.archive/%s/%s/" %(cycle,p),""), compresslevel=9)
         zf.close()
         print("Zipping %s %s complete" % (state,p))

## for state in states:
##     ZipStateTiles(state)

count = []
total = len(states)
with mp.Pool(processes=cpus) as pool:
    for instance in pool.imap_unordered(ZipStateTiles, states):
        count.append(instance)
        if (len(count)%100==0):
            print ("Approximately %2.2f%% complete" % (100*len(count)/total))
