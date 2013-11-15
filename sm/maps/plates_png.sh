#!/bin/bash
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

export NP=32
export DPI=248.3
export DPI=150

function download {

    echo Starting $1

    if [[ -d plates_$1 ]]; then
	rsync -avP --del plates_$1/ plates/
    else
	perl DownloadPlates.pl --states=$1
    fi

    [[ -f final/$1.zip ]] && rm final/$1.zip
    find plates -name "*.pdf" | 
    xargs -P ${NP} -n 1 mogrify -dither none -antialias -density ${DPI} -depth 8 -quality 00 -background white -alpha remove -alpha off -colors 15 -format png
    wait

    find plates -name "*.png"| xargs -P ${NP} -n 1 optipng -quiet
    wait

    zip -r -i "*.png" -1 -T -q final/$1.zip plates
    find plates -name "*png" |xargs rm

    rsync -avPq plates/ plates_$1/
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
