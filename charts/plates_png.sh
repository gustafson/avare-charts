#!/bin/bash
# Copyright (c) 2012-2014, Apps4av Inc. (apps4av@gmail.com) 
# Author: Zubair Khan (governer@gmail.com)
# Author: Peter A. Gustafson (peter.gustafson@wmich.edu)
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

export NP=32
export DPI=248.3
export DPI=300
export DPI=150

CYCLE=`./cyclenumber.py`

sed s/1404/${CYCLE}/ DownloadPlates.pl > tmp_DownloadPlates.pl

function download {

    echo Starting $1

    perl tmp_DownloadPlates.pl --states=$1 || exit $?

    if [[ -d plates.archive/$CYCLE/plates_$1 ]]; then
 	rsync -avP --del plates.archive/$CYCLE/plates_$1/ plates/
    else
 	perl tmp_DownloadPlates.pl --states=$1 || exit $?
    fi
    
    ## Remove special characters from file names.  These mess up xargs below.
    rename "'" "" `find plates -name "*.pdf"`
    rename "," "" `find plates -name "*.pdf"`
    
    [[ -d final ]] || mkdir final
    [[ -f final/$1.zip ]] && rm final/$1.zip
    find plates -name "*.pdf" | 
    xargs -P ${NP} -n 1 mogrify -dither none -antialias -density ${DPI} -depth 8 -quality 00 -background white -alpha remove -colors 15 -format png
    wait
    
    find plates -name "*.png"| xargs -P ${NP} -n 1 optipng -quiet
    wait
    
    zip -r -i "*.png" -1 -T -q final/$1.zip plates
    ## find plates -name "*png" | xargs rm

    [[ -d plates.archive/$CYCLE ]] || mkdir -p plates.archive/$CYCLE
    rsync -avPq plates/ plates.archive/$CYCLE/plates_$1/
    rm -fr plates

}

if [[ -d plates ]]; then rm -rf plates; fi

download PR
download DC 
download AL
download AK
download AZ
download AR
download CA
download CO
download CT
download DE
download FL
download GA
download HI
download ID
download IL
download IN
download IA
download KS
download KY
download LA
download ME
download MD
download MA
download MI
download MN
download MS
download MO
download MT
download NE
download NV
download NH
download NJ
download NM
download NY
download NC
download ND
download OH
download OK
download OR
download PA
download RI
download SC
download SD
download TN
download TX
download UT
download VT
download VA
download WA
download WV
download WI
download WY
