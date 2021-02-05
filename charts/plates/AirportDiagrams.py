import fitz #PyMuPDF
import numpy as np
import math
import sys
import os
from shapely.geometry import LineString ## Useful for line intersections

degrees = "°"
minutes = "'"

degrees.encode("utf-8").strip()
minutes.encode("utf-8").strip()

### READ IN PDF
doc = fitz.open("/dev/shm/ABQ.pdf")
page = doc[0]

### Search for latitude and longitude text lines
text = page.getTextBlocks()

def dms(v):
    ## Function for splitting into degrees and minutes
    d,m = v.split(degrees)
    m,NS = m.split(minutes[0])
    if (NS) in ["N", "E"]:
        NS=+1
    else:
        NS=-1
    return(NS*(float(d)+float(m)/60))

def isNS(t):
    ## Check if the text has degrees symbol and latitude indicator
    if t[4].find(degrees)>0 and t[4].find(minutes)>0:
        if t[4].find("N")>0 or t[4].find("S")>0:
            return [l for l in t[4].split("\n") if l]
    return False

def isEW(t):
    ## Check if the text has degrees symbol and longitude indicator
    if t[4].find(degrees)>0 and t[4].find(minutes)>0:
        if t[4].find("E")>0 or t[4].find("W")>0:
            return [l for l in t[4].split("\n") if l]
    return False

## Create list of lat lon indicators (and flatten the list)
NS = [i for j in [isNS(t) for t in text if isNS(t)] for i in j]
EW = [i for j in [isEW(t) for t in text if isEW(t)] for i in j]

## Obtain lines etc from the drawing
draw = page.getDrawings()

def rectArea(r):
    ## Calculate areas of rectangles (used to find the outer box)
    dx=r['rect'][2]-r['rect'][0]
    dy=r['rect'][3]-r['rect'][1]
    return dx*dy

## Calculate areas of all rectanges
areas = [rectArea(r) for r in draw]

## Find the biggest box by area.  These lines define the desired for
## lat lon lines.
box = draw[np.argmax(areas)]

## Get reference limits
[l0,l1,l2,l3]=box["items"]
x0 = l0[1][0]
x1 = l1[1][0]
y0 = l0[1][1]
y1 = l2[1][1]

def linelen(line):
    ## A function for calculating line length (used to eliminate
    ## candidate lines that are too short)
    [xa,ya],[xb,yb] = line
    return np.sqrt(((xb-xa)**2+(yb-ya)**2))
    
def checklinex(line, tol):
    ## Check if a line is on an x border
    if not len(line)==2:
        return False
    [xa,ya],[xb,yb] = line
    if np.abs(xa-x0)<tol:
        return True
    if np.abs(xa-x1)<tol:
        return True
    if np.abs(xb-x0)<tol:
        return True
    if np.abs(xb-x1)<tol:
        return True
    return False

def checkliney(line, tol):
    ## Check if a line is on a y border
    if not len(line)==2:
        return False
    [xa,ya],[xb,yb] = line
    if np.abs(ya-y0)<tol:
        return True
    if np.abs(ya-y1)<tol:
        return True
    if np.abs(yb-y0)<tol:
        return True
    if np.abs(yb-y1)<tol:
        return True
    return False

## Pull out unique lines from the pdf
lines = [d["items"] for d in draw if d["color"]==[0,0.0,0.0]]
lines = [i[1:] for l in lines for i in l]

## Check if they cross the outer box and are long enough to matter
linesx = [l for l in lines if checklinex(l, 1) and linelen(l)>5]
linesy = [l for l in lines if checkliney(l, 1) and linelen(l)>5]

def findLineLabelIntersection(str,linesdir):
    ## Search for where the intersections occur between lines and the
    ## lat lon text
    X0,Y0,X1,Y1 = page.searchFor(str)[0]
    label = LineString([(X0,Y0),(X1,Y1)])
    for l in linesdir: ## For each line, check if it intersects the
                       ## text box
        if (len(l))==2:  ## Do this only if the line has two points
                         ## (no boxes, circles, etc)
            [X2,Y2],[X3,Y3] = l
            if (np.abs(X2-X3)<0.5): ## If the x coords are really
                                    ## close, make slope infinite for
                                    ## consistency
                fit = [np.infty, X2]
                Y2=0
                Y3=page.MediaBox[3]
            else:
                fit = np.polyfit(x=[X2,X3],y=[Y2,Y3], deg=1) ## Slope intercept
                X2=0
                X3=page.MediaBox[2]
                Y2,Y3=np.polyval(fit,x=[X2,X3])

            ## Calculate the line angle relative to north.  Reported
            ## but not used later
            angle = 90 - math.atan(fit[0])*180/math.pi
            line = LineString([(X2,Y2),(X3,Y3)])
            if (line.intersects(label)):
                return ([str,fit,angle])

## Identify the text and their intersecting lines
latlines = [findLineLabelIntersection(ns,linesx) for ns in NS]
lonlines = [findLineLabelIntersection(ew,linesy) for ew in EW]

## Convert to decimal degrees
lats = [dms(l[0]) for l in latlines];
lons = [dms(l[0]) for l in lonlines];

## Pull just the appropriate lats for computing lat/lon linear fit
laty = [l[1][1] for l in latlines];
lonx = [l[1][1] for l in lonlines];

## Compute the bilinear fit
fitlon = np.polyfit(x=lonx,y=lons,deg=1)
fitlat = np.polyfit(x=laty,y=lats,deg=1)

## Assign control points to the pdf file
commstr = "gdal_edit.py ABQ.pdf -a_srs EPSG:4326"
for x in page.MediaBox[0::2]:
    for y in page.MediaBox[1::2]:
        X0 = np.polyval(fitlon, x=x)
        Y0 = np.polyval(fitlat, x=y)
        commstr += " -gcp %s %s %.12f %.12f 0" % (x, y, X0, Y0)
os.system(commstr)

## Some parameters to be consistent with plates
resampling = "bilinear"
size = 1900
pdfDense = (size/page.MediaBox[-1])*72
srcImg="ABQ.pdf"
highDensityTmp="tmp.tif"

## Warp the image
commstr = "rm tmp.tif; gdalwarp -r %s -q -dstalpha --config GDAL_PDF_DPI %s -t_srs EPSG:3857 %s %s" % (resampling, pdfDense, srcImg, highDensityTmp)
os.system(commstr)
