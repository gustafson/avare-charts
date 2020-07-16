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

def TMSvals(layer):
    theirlayer = layer+1
    X = range(0,2**theirlayer,2)
    x = y = range(0,2**layer,1)

    Ymax = 2**theirlayer
    
    Y = []
    for i in range(len(x)):
        Y.append(Ymax - X[i] - 2)
        
    return x, X, y, Y
        
b = "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/"
for layer in range(11):
    x, X, y, Y = TMSvals(layer)
    for i in range(len(x)):
        for j in range(len(y)):
            p = "tiles/0/"+ "/".join(map(str,[layer,x[i],y[j]])) + ".webp"
            png = p.replace("tiles/0","tiles/999").replace(".webp",".png")
            if not (os.path.exists(png)) and (os.path.exists(p)):
                ## png file name
                ## create the path
                os.makedirs("/".join(png.split("/")[0:-1]),exist_ok=True)

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
                print(png)
                print(urls)
                print(fn)
                for k in range(len(fn)):
                    urllib.request.urlretrieve(urls[k],fn[k])
                
                ms = "montage " + (" ".join(fn)) + " -geometry 256x256+0+0 " + png
                os.system("montage " + (" ".join(fn)) + " -geometry 256x256+0+0 " + png)
                td.cleanup()

#import urllib.request
#import tempfile
#import os
#import glob
#
#images = glob.glob("tiles/0/*/*/*.webp")
#
#for image in images:
#    montagefn = image.replace("tiles/0","tiles/999").replace("webp","png")
#
#    tmp=image.split("/")[2:5]
#    ourlay=int(tmp[0])
#    ourrow=int(tmp[1])
#    ourcol=int(tmp[2].split(".")[0])
#
#    if (ourlay<4):
#        theirlay = ourlay+1
#        ymaxm1 = 2**theirlay-1
#        theirrow = [ymaxm1-ourrow*2-1,ymaxm1-ourrow*2]
#        theircol = [ourcol*2, ourcol*2+1]
#        #print(image)
#        montage = []
#        if (ourlay==2):
#            print ("layer " + str(ourlay))
#            print(["ourrow","theirrow","\t","ourcol","theircol"])
#            print([ourrow,theirrow,"\t",ourcol,theircol])
#        td = tempfile.TemporaryDirectory()
#
#        if not os.path.exists(montagefn):
#            for c in theircol:
#                for r in theirrow:
#                    ourdir = "tiles/999/" + str(ourlay) + "/"+str(ourrow)
#
#                    url="https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/" + "/".join(map(str,[theirlay,c,r]))
#                    theirfn = td.name + "/" + "_".join(map(str,[c,r])) + ".jpg"
#                    print (url)
#                    print(theirfn)
#                    montage.append(theirfn)
#                    os.makedirs(ourdir,exist_ok=True)
#                    urllib.request.urlretrieve(url,theirfn)
#        print("montage " + (" ".join(montage)) + " -geometry 256x256+0+0 " + montagefn)
#        os.system("montage " + (" ".join(montage)) + " -geometry 256x256+0+0 " + montagefn)
#        td.cleanup()



#tiles/0/1/0/0.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/2/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/2/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/3/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/3/1']
#['/tmp/tmpgs_n8_l9/2_2_0.jpg', '/tmp/tmpgs_n8_l9/2_2_1.jpg', '/tmp/tmpgs_n8_l9/2_3_0.jpg', '/tmp/tmpgs_n8_l9/2_3_1.jpg']
#tiles/0/1/0/1.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/0/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/0/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/1/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/1/1']
#['/tmp/tmp2nv2rr76/2_0_0.jpg', '/tmp/tmp2nv2rr76/2_0_1.jpg', '/tmp/tmp2nv2rr76/2_1_0.jpg', '/tmp/tmp2nv2rr76/2_1_1.jpg']
#tiles/0/1/1/1.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/0/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/0/3', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/1/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/2/1/3']
#['/tmp/tmpmggj7205/2_0_2.jpg', '/tmp/tmpmggj7205/2_0_3.jpg', '/tmp/tmpmggj7205/2_1_2.jpg', '/tmp/tmpmggj7205/2_1_3.jpg']
#tiles/0/2/0/1.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/4/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/4/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/5/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/5/1']
#['/tmp/tmpgnj4xwl6/3_4_0.jpg', '/tmp/tmpgnj4xwl6/3_4_1.jpg', '/tmp/tmpgnj4xwl6/3_5_0.jpg', '/tmp/tmpgnj4xwl6/3_5_1.jpg']
#tiles/0/2/0/2.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/2/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/2/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/3/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/3/1']
#['/tmp/tmp10mo0bam/3_2_0.jpg', '/tmp/tmp10mo0bam/3_2_1.jpg', '/tmp/tmp10mo0bam/3_3_0.jpg', '/tmp/tmp10mo0bam/3_3_1.jpg']
#tiles/0/2/0/3.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/0/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/0/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/1/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/1/1']
#['/tmp/tmph5jjv27h/3_0_0.jpg', '/tmp/tmph5jjv27h/3_0_1.jpg', '/tmp/tmph5jjv27h/3_1_0.jpg', '/tmp/tmph5jjv27h/3_1_1.jpg']
#tiles/0/2/1/2.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/2/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/2/3', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/3/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/3/3']
#['/tmp/tmpsjr0s6_8/3_2_2.jpg', '/tmp/tmpsjr0s6_8/3_2_3.jpg', '/tmp/tmpsjr0s6_8/3_3_2.jpg', '/tmp/tmpsjr0s6_8/3_3_3.jpg']
#tiles/0/2/3/2.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/2/6', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/2/7', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/3/6', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/3/3/7']
#['/tmp/tmp996tauyi/3_2_6.jpg', '/tmp/tmp996tauyi/3_2_7.jpg', '/tmp/tmp996tauyi/3_3_6.jpg', '/tmp/tmp996tauyi/3_3_7.jpg']
#tiles/0/3/0/3.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/8/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/8/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/9/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/9/1']
#['/tmp/tmptncbb1g2/4_8_0.jpg', '/tmp/tmptncbb1g2/4_8_1.jpg', '/tmp/tmptncbb1g2/4_9_0.jpg', '/tmp/tmptncbb1g2/4_9_1.jpg']
#tiles/0/3/0/4.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/1']
#['/tmp/tmpqcu9d48c/4_6_0.jpg', '/tmp/tmpqcu9d48c/4_6_1.jpg', '/tmp/tmpqcu9d48c/4_7_0.jpg', '/tmp/tmpqcu9d48c/4_7_1.jpg']
#tiles/0/3/0/5.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/1']
#['/tmp/tmpl9k52e5r/4_4_0.jpg', '/tmp/tmpl9k52e5r/4_4_1.jpg', '/tmp/tmpl9k52e5r/4_5_0.jpg', '/tmp/tmpl9k52e5r/4_5_1.jpg']
#tiles/0/3/0/6.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/2/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/2/1', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/3/0', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/3/1']
#['/tmp/tmpdf4qqkkn/4_2_0.jpg', '/tmp/tmpdf4qqkkn/4_2_1.jpg', '/tmp/tmpdf4qqkkn/4_3_0.jpg', '/tmp/tmpdf4qqkkn/4_3_1.jpg']
#tiles/0/3/1/4.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/3', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/3']
#['/tmp/tmpry_e413h/4_6_2.jpg', '/tmp/tmpry_e413h/4_6_3.jpg', '/tmp/tmpry_e413h/4_7_2.jpg', '/tmp/tmpry_e413h/4_7_3.jpg']
#tiles/0/3/1/5.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/3', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/3']
#['/tmp/tmpsrwqefdr/4_4_2.jpg', '/tmp/tmpsrwqefdr/4_4_3.jpg', '/tmp/tmpsrwqefdr/4_5_2.jpg', '/tmp/tmpsrwqefdr/4_5_3.jpg']
#tiles/0/3/1/6.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/2/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/2/3', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/3/2', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/3/3']
#['/tmp/tmpms7x2lyz/4_2_2.jpg', '/tmp/tmpms7x2lyz/4_2_3.jpg', '/tmp/tmpms7x2lyz/4_3_2.jpg', '/tmp/tmpms7x2lyz/4_3_3.jpg']
#tiles/0/3/2/4.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/4', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/5', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/4', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/5']
#['/tmp/tmp2ve7_k6l/4_6_4.jpg', '/tmp/tmp2ve7_k6l/4_6_5.jpg', '/tmp/tmp2ve7_k6l/4_7_4.jpg', '/tmp/tmp2ve7_k6l/4_7_5.jpg']
#tiles/0/3/2/5.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/4', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/5', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/4', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/5']
#['/tmp/tmp1yw0ovxj/4_4_4.jpg', '/tmp/tmp1yw0ovxj/4_4_5.jpg', '/tmp/tmp1yw0ovxj/4_5_4.jpg', '/tmp/tmp1yw0ovxj/4_5_5.jpg']
#tiles/0/3/7/4.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/14', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/6/15', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/14', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/7/15']
#['/tmp/tmpmr5g2g2_/4_6_14.jpg', '/tmp/tmpmr5g2g2_/4_6_15.jpg', '/tmp/tmpmr5g2g2_/4_7_14.jpg', '/tmp/tmpmr5g2g2_/4_7_15.jpg']
#tiles/0/3/7/5.webp
#['https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/14', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/4/15', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/14', 'https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/4/5/15']
#['/tmp/tmp0atpn57r/4_4_14.jpg', '/tmp/tmp0atpn57r/4_4_15.jpg', '/tmp/tmp0atpn57r/4_5_14.jpg', '/tmp/tmp0atpn57r/4_5_15.jpg']
