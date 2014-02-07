#!/bin/bash
# Copyright (c) 2014, Apps4Av Inc. (apps4av@gmail.com)
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
rm -f *.txt *.gfw *.gif *.zip *.png

wget http://radar.weather.gov/ridge/Conus/RadarImg/latest_radaronly.gif
wget http://radar.weather.gov/ridge/Conus/RadarImg/latest_radaronly.gfw
wget http://radar.weather.gov/ridge/Conus/RadarImg/mosaic_times.txt

convert latest_radaronly.gif -resize 40% latest_radaronly.png
mv latest_radaronly.gfw latest_radaronly.txt
head -1 latest_radaronly.txt > latest.txt
tail -3 latest_radaronly.txt >> latest.txt
tail -1 mosaic_times.txt >> latest.txt

zip /home/apps4av/mamba.dreamhosters.com/new/conus.zip latest.txt latest_radaronly.png
rm -f *.txt *.gfw *.gif *.zip *.png
