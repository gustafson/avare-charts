#!/bin/bash
# Copyright (c) 2012, Zubair Khan (governer@gmail.com)
# Copyright (c) 2013, Peter A. Gustafson (peter.gustafson@wmich.edu)
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
DPI=150

LINES=`cat ads.txt`
for line in $LINES ; do
	`echo $line | sed "s/\(.*\),\(.*\)/wget http:\/\/aeronav.faa.gov\/d-tpp\/$1\/\2/"`
	`echo $line | sed 's/\(.*\),\(.*\)/mkdir plates\/\1/'`
	`echo $line | sed 's/\(.*\),\(.*\)/mv \2 plates\/\1\/AIRPORT-DIAGRAM.PDF/'`
done

find plates -name "AIRPORT-DIAGRAM.PDF" | 
xargs -P ${NP} -n 1 mogrify -depth 8 -quality 00 -background white  -alpha remove -alpha off -density ${DPI} -format png 
wait

find plates -name "*.png" |
xargs -P ${NP} -n 1 optipng -quiet
wait

zip -r -i *.png -1 -T -q final/AirportDiagrams.zip plates
