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

if [[ $# -lt 1 ]]; then
    echo Cycle number argument required;
    exit
fi

if [[ $# -eq 2 ]]; then
    CMD=echo
fi
    
CYCLE=$1

for a in NE NC NW SE SC SW AK; do
    if [[ -f final/ELUS_${a}.zip ]]; then
	rm final/ELUS_${a}.zip; 
    fi 
done

for LOC in ul ur ll lr c; do # Do center last.  It won't add any tiles but will correctly define the set for the tile.
    $CMD zip -1 -q final/ELUS_NE.zip `sqlite3 maps.el.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} >= -85) and (level != ' 4') and name like '%tiles/${CYCLE}/ifr/48%';"`
    $CMD sqlite3 maps.el.db    		    "update files set info='ELUS_NE' where (lat${LOC} >= 38) and (lon${LOC} >= -85) and name like '%tiles/${CYCLE}/ifr/48%';"

    $CMD zip -1 -q final/ELUS_NC.zip `sqlite3 maps.el.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and (level != ' 4') and name like '%tiles/${CYCLE}/ifr/48%';"`
    $CMD sqlite3 maps.el.db 		    "update files set info='ELUS_NC' where (lat${LOC} >= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and name like '%tiles/${CYCLE}/ifr/48%';"

    $CMD zip -1 -q final/ELUS_NW.zip `sqlite3 maps.el.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} <= -110) and (level != ' 4') and name like '%tiles/${CYCLE}/ifr/48%';"`
    $CMD sqlite3 maps.el.db 		    "update files set info='ELUS_NW' where (lat${LOC} >= 38) and (lon${LOC} <= -110) and name like '%tiles/${CYCLE}/ifr/48%';"

    $CMD zip -1 -q final/ELUS_SE.zip `sqlite3 maps.el.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} >= -85) and (level != ' 4') and name like '%tiles/${CYCLE}/ifr/48%';"`
    $CMD sqlite3 maps.el.db 		    "update files set info='ELUS_SE' where (lat${LOC} <= 38) and (lon${LOC} >= -85) and name like '%tiles/${CYCLE}/ifr/48%';"

    $CMD zip -1 -q final/ELUS_SC.zip `sqlite3 maps.el.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and (level != ' 4') and name like '%tiles/${CYCLE}/ifr/48%';"`
    $CMD sqlite3 maps.el.db 		    "update files set info='ELUS_SC' where (lat${LOC} <= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and name like '%tiles/${CYCLE}/ifr/48%';"

    $CMD zip -1 -q final/ELUS_SW.zip `sqlite3 maps.el.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} <= -110) and (level != ' 4') and name like '%tiles/${CYCLE}/ifr/48%';"`
    $CMD sqlite3 maps.el.db 		    "update files set info='ELUS_SW' where (lat${LOC} <= 38) and (lon${LOC} <= -110) and name like '%tiles/${CYCLE}/ifr/48%';"
done

$CMD zip -1 -q final/ELUS_AK.zip `sqlite3 maps.el.db "select name from files where (level != ' 4') and name like '%tiles/${CYCLE}/ifr/ak%';"`
$CMD sqlite3 maps.el.db 		    "update files set info='ELUS_AK' where name like '%tiles/${CYCLE}/ifr/ak%';"


## The four corner methods was pulling too many tiles.  This illustrates the problem.
## sqlite3 maps.el.db "select name, latul, lonul, latc, lonc from files where ((latul >= 38) and (lonul >= -85)) and ((latc < 38) and (lonc < -85)) and (level != ' 4') and name like '%tiles/${CYCLE}/ifr/48%';"
