#!/bin/bash
#Copyright (c) 2015, Apps4av Inc. (apps4av@gmail.com) 
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# author zkhan

NP=`cat /proc/cpuinfo |grep processor|wc -l`

# The navcan website has two versions, current and next, which update every 56
# days. Get the next one when preparing charts.
FILE=CanadianAirportCharts_Next.pdf
CYCLE=$(./cyclenumber.sh)
export FILE
export CYCLE

# This is a big download
wget -N http://www.navcanada.ca/en/products-and-services/Documents/$FILE

[[ -d plates ]] || mkdir plates

# Find number of pages in this doc, for our FOR loop
PAGES=`pdfinfo $FILE  | grep Pages | sed 's/Pages:\s*//'`
export PAGES

rm -fr plates/C*
function generateimages(){
    i=${0}
    echo Processing page $i of $PAGES
    
    # Find the name of the airport, which is prefixed on airport diagram page
    # with -AD, many cases may exist, in which case take the last line
    AD=`pdftotext -f ${i} -l ${i} ${FILE} - | grep '\-AD' | tail -n 1`
    #AD=`pdf2txt -p ${i} ${FILE}  | grep '\-AD' | tail -n 1`
    # If not an AD page, continue to next page
    if [[ ${AD} ]]; then
	if [[ $AD != *"-AD" ]]; then
            return
	fi

	# Find airport name as in CYKD (all 4 digits/letters)
	IMG=`echo $AD | cut -b 1-4`
	# If already processed, continue to next
	# This logic exists to also use English version of the chart as French
	# follows English
	if [[ -d plates/$IMG ]]; then
	    return
	fi

	## # Avare plates format
	mkdir -p plates/$IMG
	# Page - 1 for convert
	PAGE=`expr ${i} - 1`
	echo ${i} ${FILE} ${AD} ${PAGE} $FILE[$PAGE]
	
	# Convert to ~1400x800 pixel image
	## PNG not used anymore
	convert -dither none -density 150x150 -depth 8 -quality 00 -background white -alpha remove -alpha off -colors 15 -trim +repage $FILE[$PAGE] plates/$IMG/AIRPORT-DIAGRAM.png && optipng -quiet plates/$IMG/AIRPORT-DIAGRAM.png

	# convert to efficient webp via stream
	## convert -dither none -density 150x150 -depth 8 -quality 00 -background white -alpha remove -alpha off -colors 15 -trim +repage $FILE[$PAGE] png:- | cwebp -quiet -z 9 -lossless -o plates/$IMG/AIRPORT-DIAGRAM.webp -- -

    fi

}
export -f generateimages

# Process all pages
for i in `seq 1 $PAGES`; do
    echo $i
done | xargs -n1 -P${NP} bash -c generateimages

# Zip up the result
## PNG no longer created
## rm -f final/CAN_ADS.zip
## echo ${CYCLE} > CAN_ADS
## ls plates/C???/*png >> CAN_ADS
## zip -9 final/CAN_ADS.zip plates/C???/AIRPORT-DIAGRAM.png CAN_ADS

rm -f final/CAN_ADS.zip
echo ${CYCLE} > CAN_ADS
ls plates/C???/*png >> CAN_ADS
zip -9 final/CAN_ADS.zip plates/C???/*png CAN_ADS
