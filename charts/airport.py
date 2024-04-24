#!/usr/bin/env python

# Copyright (c) 2024, Peter A. Gustafson
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
#     * Redistributions of source code must retain the above copyright
#     * notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#     * copyright notice, this list of conditions and the following
#     * disclaimer in the documentation and/or other materials
#     * provided with the distribution.
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
#

## Open the file, clean it up, and find the airports
with open('APT.txt', 'r', encoding="iso-8859-1") as f:
    data = f.read().replace(',',' ').split('\n')
    APTs = [i for i,l in enumerate(data) if l[0:3]=='APT']
    ## Add the last line of the file
    APTs.append(len(data))
  
## Format the fuels
def fuels (fuel):
    ftype = []
    if '100LL' in fuel:
        ftype.append('100LL(Blue)')
        fuel=fuel.replace('100LL','')
    if '100' in fuel:
        ftype.append('100(Green)')
        fuel=fuel.replace('100','')
    if '80' in fuel:
        ftype.append('80(Red)')
        fuel=fuel.replace('80','')
    if 'MOGAS' in fuel:
        ftype.append('MOGAS')
        fuel=fuel.replace('MOGAS','')
    if 'UL94' in fuel:
        ftype.append('UL94')
        fuel=fuel.replace('UL94','')
    if 'UL91' in fuel:
        ftype.append('UL91')
        fuel=fuel.replace('UL91','')
    if 'J8+10' in fuel:
        ftype.append('Jet-J8+10')
        fuel=fuel.replace('J8+10','')
    if 'J10' in fuel:
        ftype.append('Jet-J10')
        fuel=fuel.replace('J10','')
    if 'J8' in fuel:
        ftype.append('Jet-J8')
        fuel=fuel.replace('J8','') 
    if 'J5' in fuel:
        ftype.append('Jet-J5')
        fuel=fuel.replace('J5','')
    if 'J' in fuel:
        ftype.append('Jet-J')
        fuel=fuel.replace('J','')
    fuel = fuel.strip()
    import re
    fuel = re.sub(r"\s+", " ", fuel)
    if 'A' in fuel:
        ftype.append('Jet-')
    return " ".join(ftype)

def getstr (substr, b, e):
    return(substr[b:(b+e)])

def getlat(lat):
    latn = lat.strip()
    if latn:
        latn = float(getstr(lat, 0,   2 )) / 1;
        latn += float(getstr(lat, 3,   2 )) / 60;
        latn += float(getstr(lat, 6,   7 )) / 3600;
        latl = getstr(lat, 13, 1)
        if latl == 'S':
            latn*=-1
    return(str(latn))

def getlon(lon):
    lonn = lon.strip()
    if lonn:
        lonn = float(getstr(lon, 0,   3 )) / 1;
        lonn += float(getstr(lon, 4,   2 )) / 60;
        lonn += float(getstr(lon, 7,   7 )) / 3600;
        lonl = getstr(lon, 14, 1 )
        if lonl == 'W':
            lonn*=-1
    return(str(lonn))

def getaptinfo(substr, lid):

    ## Get the rest of the data
    atype = getstr(substr, 14,  12)
    name = getstr(substr, 133, 50)
    state = getstr(substr, 91, 2)
    city = getstr(substr, 93, 40)
    manager    = getstr(substr, 355, 35)
    managertel = getstr(substr, 507, 16)
    var  = getstr(substr, 586, 3)
    fuel = fuels(getstr(substr, 900, 40))
    use        = getstr(substr, 185, 2)
    elevation  = getstr(substr, 578, 7)
    patterna   = getstr(substr, 593, 4)
    ctaff      = getstr(substr, 988, 7)
    unicom     = getstr(substr, 981, 7)
    atct       = getstr(substr, 980, 1)
    fee        = getstr(substr, 1002, 1)
    lightsched = getstr(substr, 966, 7)
    segcircle  = getstr(substr, 995, 4)
    c1 = getstr(substr, 877, 1)
    c2 = getstr(substr, 878, 1)
    custom = c1+c2
    beacon = getstr(substr, 999, 3)
    tel    = getstr(substr, 762, 16)

    ## Get lat and long, fixing to decimal
    latn  = getlat(getstr(substr,   523, 14 ))
    lonn  = getlon(getstr(substr,   550, 15 ))

    ## Print the output
    out = [lid,latn,lonn,
           atype,name,use,tel,
           manager,managertel,elevation,var,
           patterna,fuel,custom,beacon,lightsched,
           segcircle,atct,unicom,ctaff,fee,state,city]
    out = [i.strip() for i in out]
    return ",".join(out) + '\n'

def getrwyinfo(substr, lid):
    out = ""

    ## Each line is two runways
    RWYs = [i for i,l in enumerate(substr) if l[0:3]=='RWY']
    for RWY in RWYs:
        RWY = substr[RWY]
        rlen = getstr(RWY, 23, 5)
        rwid = getstr(RWY, 28, 4)
        rtype = getstr(RWY, 32, 12)
        run0 = getstr(RWY, 65, 3)
        run0lat = getlat(getstr(RWY, 88, 14))
        run0lon = getlon(getstr(RWY, 115, 15))

        run0elev = getstr(RWY, 142, 7)
        run0true = getstr(RWY, 68, 3)
        run0dt = getstr(RWY, 217, 4)
        run0light = getstr(RWY, 237, 8)
        run0ils = getstr(RWY, 71, 10)
        run0vgsi = getstr(RWY, 228, 5)
        run0pattern = getstr(RWY, 81, 1)

        run1 = getstr(RWY, 287, 3)
        run1lat = getlat(getstr(RWY, 310, 14))
        run1lon = getlon(getstr(RWY, 337, 15))
        run1elev = getstr(RWY, 364, 7)
        run1true = getstr(RWY, 290, 3)
        run1dt =  getstr(RWY, 439, 4)
        run1light = getstr(RWY, 459, 8)
        run1ils = getstr(RWY, 293, 10)
        run1vgsi = getstr(RWY, 450, 5)
        run1pattern = getstr(RWY, 303, 1)
        _ = [lid,rlen,rwid,rtype,run0,run1,
             run0lat,run1lat,run0lon,run1lon,run0elev,run1elev,
             run0true,run1true,run0dt,run1dt,run0light,run1light,
             run0ils,run1ils,run0vgsi,run1vgsi,run0pattern,run1pattern]
        _ = [o.strip() for o in _]
        out += ','.join(_) + '\n'
    return out

## Operate on the whole file
APTcsv = ""
RWYcsv = ""
for i in range(len(APTs)-1):
    ## Get the data for the airport
    substr = data[APTs[i]]

    ## Get ID, sub local ID when ICAO is not available
    lid   = getstr(substr, 27,  4).strip()
    ICAO = getstr(substr,1210,4)
    if not (ICAO=='    '): ## If there is an ICAO code, use it
        lid = ICAO
   
    ############################################
    ## if not (ICAO[1:]==lid or lid==ICAO):
    ##     if not (ICAO=='    '):
    ##         print('Miss match', ICAO, lid)
    ############################################

    ## Airport info
    APTcsv += getaptinfo(substr, lid)

    ## Runway info
    j = APTs[i],APTs[i+1]
    substr = data[j[0]:j[1]]
    RWYcsv += getrwyinfo(substr, lid)

## Write output data
with open('airport-tmp.csv', 'w') as f:
    f.write(APTcsv)
with open('runway-tmp.csv', 'w') as f:
    f.write(RWYcsv)
