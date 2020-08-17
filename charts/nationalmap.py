#!/usr/bin/python

# Copyright (c) 2020 Peter A. Gustafson (peter.gustafson@wmich.edu)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


import sys
import os
import tempfile
import urllib.request
import urllib.error

from PIL import Image
import imghdr ## For checking image type

from pathlib import Path  ## for touch

QUALITYCONTROL=False

print(sys.argv)

if (len(sys.argv)==4):
    QUALITYCONTROL=True
    CPU = int(sys.argv[-3])
    CPUS = int(sys.argv[-2])
elif (len(sys.argv)==3):
    CPU = int(sys.argv[-2])
    CPUS = int(sys.argv[-1])
else:
    CPU = 0
    CPUS = 1

## Create a directory to store a single black image representing tiles
## don't download correctly (returned as transparent png or just missing).
## The app background color is black.

bd = tempfile.TemporaryDirectory()
blackimage = bd.name  + "/black.jpg"
blackimage = "/dev/shm/black.jpg"
os.system("convert -size 256x256 xc:black " + blackimage)


## estimate the cumulative total number of tiles by layer
print("Estimations of number of tiles by layer:")
total=0
for i in range(16):
    total+=(2**i)**2
    print([i,(2**i)**2,total])


## Resolution by layer
print("Layer resolutions:")
for i in range(16):    
    print([i,2*20026376.39/512/(2**i)])


## Define a function which relates TMS to our own
def TMSvals(layer):
    theirlayer = layer+1
    X = range(0,2**theirlayer,2)
    x = y = range(0,2**layer,1)

    Ymax = 2**theirlayer
    
    Y = []
    for i in range(len(x)):
        Y.append(Ymax - X[i] - 2)
        
    return x, X, y, Y


## Location baseline
b = "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/"

count = 0
## Do the work for each layer
for layer in range(0,13):
    x, X, y, Y = TMSvals(layer)
    for i in range(len(x)):
        for j in range(len(y)):
            count += 1
            if not (count%CPUS == CPU):
                continue
            
            sec   = "tiles/0/"+ "/".join(map(str,[layer,x[i],y[j]])) + ".webp"
            png   = sec.replace("tiles/0","tiles/999").replace(".webp",".png")
            jpg   = sec.replace("tiles/0","tiles/999").replace(".webp",".jpg")
            web   = sec.replace("tiles/0","tiles/999")
            empty = sec.replace("tiles/0","tiles/999").replace(".webp",".empty")

            CREATE=False

            ## Image URLS.  Their rows go across  (Not this could be faster if delayed but I want it for QC
            urls = [
                b + "/".join(map(str,[layer+1,Y[j]+0,X[i]+0])),
                b + "/".join(map(str,[layer+1,Y[j]+0,X[i]+1])),
                b + "/".join(map(str,[layer+1,Y[j]+1,X[i]+0])),
                b + "/".join(map(str,[layer+1,Y[j]+1,X[i]+1]))]

            ## This code now helps to document why the tiles were problematic (available, not available, etc)
            if (QUALITYCONTROL) and (not os.path.exists(empty)):

                if (os.path.exists(jpg)):
                    testimg = jpg
                    testpixel = True
                elif (os.path.exists(png)):
                    testimg = png
                    testpixel = True
                else:
                    testpixel = False
                    CREATE=True

                if (testpixel):
                    im = Image.open(testimg)
                    ## im.show()
                    pix = im.load()

                    ## Remake the image if one of the subimages is gray or black (empty)
                    try:
                        if (pix[255,255]==(128,128,128) or
                            pix[255,256]==(128,128,128) or
                            pix[256,255]==(128,128,128) or
                            pix[255,256]==(128,128,128) or
                            pix[255,255]==(0,0,0) or
                            pix[255,256]==(0,0,0) or
                            pix[256,255]==(0,0,0) or
                            pix[255,256]==(0,0,0)):
                            CREATE=True
                            os.system("rm " + testimg)
                            print("Attempting to update image "+testimg)
                    except: # Necessary for the images that came back as png
                        CREATE=True

            if ((layer<8) or (os.path.exists(sec))) and (not (os.path.exists(jpg) or os.path.exists(png))):
                CREATE=True
            elif (layer>10):
                ## We're really interested if sec exists at level
                div = 2**(layer-10)
                nx = int(x[i]/div)
                ny = int(y[j]/div)
                sec2 = "tiles/0/"+ "/".join(map(str,[10,nx,ny])) + ".webp"
                CREATE = (os.path.exists(sec2)) and (not (os.path.exists(jpg)))
                if CREATE: print("Creating " + jpg + " for " + sec2)

            ## Create a new tile only if the target is missing and (an
            ## equivalent sectional exist or it is a low level tile)
            if CREATE:
                ## png file name
                ## create the path
                os.makedirs("/".join(jpg.split("/")[0:-1]),exist_ok=True)

                ## Create a safe tmp directory
                td = tempfile.TemporaryDirectory()

                fn = [
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+0,X[i]+0])) + ".jpg",
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+0,X[i]+1])) + ".jpg",
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+1,X[i]+0])) + ".jpg",
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+1,X[i]+1])) + ".jpg"
                    ]

                ## Do the downloads and handle errors
                comment=""
                for k in range(3,-1,-1): ## Go backwards
                    ## If the download fails, Use the black background tile to represent missing data
                    try:
                        resp = urllib.request.urlopen(urls[k])
                        with open(fn[k], "wb") as f:
                            f.write(resp.read())
                            f.close()
                            ftype = imghdr.what(fn[k])
                            if(ftype=="png"):
                                ## Change to a png extension
                                os.system("mv " + fn[k] + " " + fn[k] + ".png")
                                fn[k]+=".png"
                                comment+="1"
                            elif(ftype=="jpeg"):
                                ## Change to a jpg extension
                                os.system("mv " + fn[k] + " " + fn[k] + ".jpg")
                                fn[k]+=".jpg"
                                comment+="1"
                            else:
                                print ("Image format is " + ftype)
                                comment+="-2"

                    except urllib.error.URLError:
                        print("File not available on server, sub black image")
                        fn[k]+=".jpg"
                        os.system("cp " + blackimage + " " + fn[k])
                        comment+="0"

                    except urllib.error.HTTPError:
                        print("Unknown HTTP Error")
                        comment+="-1"

                ## As long as there was one successful download, create the tile
                # if not ( fn == ["xc:transparent","xc:transparent","xc:transparent","xc:transparent"] ): ## This for png
                if not ( fn == [blackimage,blackimage,blackimage,blackimage] ):

                    if (str(fn).find("png")>0): ## If a png image exists, create a png image
                        if (not (os.path.exists(png))):
                            ms = "montage " + (" ".join(fn)) + " -geometry 256x256+0+0 " + png
                            os.system(ms)
                            comment = "exiftool -Comment=" + comment + " " + png
                            os.system(comment)

                    else: # For jpg only images
                        if (not (os.path.exists(jpg))):
                            ## Commands for creating jpgs
                            jpegtran = [
                                "/home/pete/software/jpeg-9d/jpegtran -crop 512x512+0+0 -optimize -progressive -outfile ",
                                "/home/pete/software/jpeg-9d/jpegtran -drop +256+0 " + fn[1] + " -optimize -progressive -outfile ",
                                "/home/pete/software/jpeg-9d/jpegtran -drop +0+256 " + fn[2] + " -optimize -progressive -outfile ",
                                "/home/pete/software/jpeg-9d/jpegtran -drop +256+256 " + fn[3] + " -optimize -progressive -outfile "
                            ]

                            ## Run the jpegtran commands
                            for k in range(4):
                                os.system(jpegtran[k] + fn[0] + " " + fn[0])

                            ## Finalize the comment
                            comment = "exiftool -Comment=" + comment + " " + fn[0]
                            os.system(comment)
                            os.system("mv " + fn[0] + " " + jpg)

                ## Record that no images were found
                else:
                    print ("No image found, recording empty")
                    Path(empty).touch()

                ## Print relevant log info and delete the tmp directory
                print(jpg)
                print(urls)
                # print(fn)
                td.cleanup()

## Clean up the extra tile
bd.cleanup()
