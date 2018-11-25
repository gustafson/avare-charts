#!/bin/bash
# Copyright (c) 2012-2014, Apps4av Inc. (apps4av@gmail.com) 
# Author: Zubair Khan (governer@gmail.com)
# Author: Peter A. Gustafson (peter.gustafson@wmich.edu)
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
#

NP=16

CYCLE=`./cycledates.sh 56`
CYCLENUMBER=`./cyclenumber.sh`

[[ -d afd ]] && rm -fr afd
mkdir afd

sed s/29MAY2014/${CYCLE}/ dlafd.pl > tmp_dlafd.pl
perl tmp_dlafd.pl || exit

## DPI=240.9  #Android limited plates size 2400x
DPI=225

## ## Convert to png
find afd -name "*.pdf" | 
xargs -P ${NP} -n 1 mogrify -trim +repage -dither none -antialias -density ${DPI} -depth 8 -quality 00 -background white  -alpha remove -alpha off -colors 15 -format png 
wait

## Optimize the png for file size and rendering
find afd -name "*.png" | 
xargs -P ${NP} -n 1 optipng -quiet
wait

find afd -name "*.pdf" | 
xargs -P ${NP} -n 1 mogrify -trim +repage -dither none -antialias -density ${DPI} -depth 8 -quality 00 -background white  -alpha remove -alpha off -colors 15 -format webp -define webp:lossless=true,method=6
wait



## Zip the files
for file in NE NC NW SE SC SW EC AK PAC; do
    rm -f final/AFD_${file}.zip
    echo $CYCLENUMBER > AFD_${file}
    ls afd/*${file,,}*.png >> AFD_${file};
    zip -9 final/AFD_${file}.zip afd/*${file,,}*.png AFD_${file}

    rm -f final_webp/AFD_${file}.zip
    echo $CYCLENUMBER > AFD_${file}
    ls afd/*${file,,}*.webp >> AFD_${file};
    zip -9 final_webp/AFD_${file}.zip afd/*${file,,}*.webp AFD_${file}
done

rm -rf afd
