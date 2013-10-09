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

rm -f *.gz *.csv *.stripped *.xml *.db

CMD="http://aviationweather.gov/adds/dataserver_current/current/"

FL=aircraftreports.cache.xml
wget ${CMD}/${FL}.gz
gzip -d ${FL}.gz 
perl apirep.pl > apirep.csv

FL=airsigmets.cache.xml
wget ${CMD}/${FL}.gz
gzip -d ${FL}.gz
perl airsig.pl > airsig.csv

FL=tafs.cache.xml
wget ${CMD}/${FL}.gz
gzip -d ${FL}.gz
perl tafs.pl > tafs.csv

FL=metars.cache.xml
wget ${CMD}/${FL}.gz
gzip -d ${FL}.gz
perl metars.pl > metars.csv

sqlite3 weather.db < import.sql

rm -f /home/apps4av/mamba.dreamhosters.com/new/weather.zip
zip /home/apps4av/mamba.dreamhosters.com/new/weather.zip weather.db
rm -f *.gz *.csv *.xml *.db
