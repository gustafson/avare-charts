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

# The navcan website has two versions, current and next, which update every 56
# days. Get the next one when preparing charts.
FILE=CanadianAirportCharts_Next.pdf

# This is a big download
wget -N http://www.navcanada.ca/EN/products-and-services/Documents/$FILE

[[ -d plates ]] || mkdir plates

# Find number of pages in this doc, for our FOR loop
PAGES=`pdfinfo $FILE  | grep Pages | sed 's/Pages:\s*//'`
echo Checking $PAGES


# Process all pages
for i in `seq 1 $PAGES`;
do
    # Find the name of the airport, which is prefixed on airport diagram page
    # with -AD, many cases may exist, in which case take the last line
    AD=`pdftotext -f $i -l $i $FILE - | grep '\-AD' | tail -n 1`
    #AD=`pdf2txt -p $i $FILE  | grep '\-AD' | tail -n 1`
    # If not an AD page, continue to next page
    if [[ $AD != *"-AD" ]]
    then
        continue
    fi
    # Find airport name as in CYKD (all 4 digits/letters)
    IMG=`echo $AD | cut -b 1-4`
    # If already processed, continue to next
    # This logic exists to also use English version of the chart as French
    # follows English
    if [ -d plates/$IMG ]; then
        continue
    fi
    # Avare plates format
    mkdir -p plates/$IMG
    # Page - 1 for convert
    PAGE=`expr $i - 1`
    # Convert to ~1400x800 pixel image
    convert -density 150x150 $FILE[$PAGE] plates/$IMG/AIRPORT-DIAGRAM.png
done

# Zip up the result
zip CAN_ADS.zip -r -i*.png plates
