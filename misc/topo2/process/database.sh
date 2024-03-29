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

function process {
	file=$1
	gdal_translate -of jpeg -co QUALITY=50 $file.tif $file.jpeg
	rm -f $file.jpeg.aux.xml
	cmp -s $file.jpeg black_tile_jpeg
	RETVAL=$?
	if [ $RETVAL -eq 0 ]; then
		echo removing $file.jpeg because it has no info
		rm $file.jpeg
	fi
	echo "$file.jpeg,`python coords.py $file.tif`" >> database$((count%${numexec})).csv
}

numexec=6
rm maps.db
rm database*.csv
sqlite3 maps.db 'create table files(name varchar(64),lonul float,latul float,lonll float,latll float,lonur float,latur float,lonlr float,latlr float,lonc float,latc float,info text,level int);'
count=0;
for file in `find tiles -name "*.tif" -print | sed 's/.tif'// | sort`; do
	process "$file" &
	let count+=1
	[[ $((count%${numexec})) -eq 0 ]] && wait 
done
for i in database*.csv; do cat $i >> files.csv; done
