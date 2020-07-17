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


import os
import tempfile
import urllib.request

## estimate the cumulative total number of tiles by layer
total=0
for i in range(16):
    total+=(2**i)**2
    print([i,(2**i)**2,total])


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

## Do the work for each layer
for layer in range(12):
    x, X, y, Y = TMSvals(layer)
    for i in range(len(x)):
        for j in range(len(y)):
            sec = "tiles/0/"+ "/".join(map(str,[layer,x[i],y[j]])) + ".webp"
            png = sec.replace("tiles/0","tiles/999").replace(".webp",".png")
            jpg = sec.replace("tiles/0","tiles/999").replace(".webp",".jpg")
            web = sec.replace("tiles/0","tiles/999")

            ## Create a new tile only if the target is missing and (an
            ## equivalent sectional exist or it is a low level tile)
            if ((layer<7) or (os.path.exists(sec))) and (not (os.path.exists(jpg))):
                ## png file name
                ## create the path
                os.makedirs("/".join(png.split("/")[0:-1]),exist_ok=True)

                ## Create a safe tmp directory
                td = tempfile.TemporaryDirectory()

                fn = [
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+0,X[i]+0])) + ".jpg",
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+0,X[i]+1])) + ".jpg",
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+1,X[i]+0])) + ".jpg",
                    td.name + "/" + "_".join(map(str,[layer+1,Y[j]+1,X[i]+1])) + ".jpg"
                    ]

                ## Their rows go across
                urls = [
                    b + "/".join(map(str,[layer+1,Y[j]+0,X[i]+0])),
                    b + "/".join(map(str,[layer+1,Y[j]+0,X[i]+1])),
                    b + "/".join(map(str,[layer+1,Y[j]+1,X[i]+0])),
                    b + "/".join(map(str,[layer+1,Y[j]+1,X[i]+1]))]

                for k in range(len(fn)):
                    ## If the download fails, create a transparent tile to replace the missing info
                    try:
                        urllib.request.urlretrieve(urls[k],fn[k])
                    except:
                        fn[k] = "xc:transparent"

                ## Commands for creating jpgs
                jpegtran = [
                    "/home/pete/software/jpeg-9d/jpegtran -crop 512x512+0+0 -optimize -progressive -outfile ",
                    "/home/pete/software/jpeg-9d/jpegtran -drop +256+0 " + fn[1] + " -optimize -progressive -outfile ",
                    "/home/pete/software/jpeg-9d/jpegtran -drop +0+256 " + fn[2] + " -optimize -progressive -outfile ",
                    "/home/pete/software/jpeg-9d/jpegtran -drop +256+256 " + fn[3] + " -optimize -progressive -outfile "
                ]

                ## As long as there was one successful download, create the tile
                if not ( fn == ["xc:transparent","xc:transparent","xc:transparent","xc:transparent"] ):
                    if (not (os.path.exists(png))):
                        ms = "montage " + (" ".join(fn)) + " -geometry 256x256+0+0 " + png
                        os.system(ms)
                    
                    if (not (os.path.exists(jpg))):
                        for k in range(4):
                            # print(jpegtran[k] + fn[0] + " " + fn[0])
                            os.system(jpegtran[k] + fn[0] + " " + fn[0])

                        os.system("mv " + fn[0] + " " + jpg)

                ## Print relevant log info and delete the tmp directory
                print(png)
                print(urls)
                print(fn)
                td.cleanup()
