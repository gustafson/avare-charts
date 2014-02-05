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
 
#cp -ard ../usgs/new/tiles/5 tiles


for a in NE NC NW SE SC SW AK PR HI; do
    if [[ -f final/ELEV_${a}.zip ]]; then
	rm final/ELEV_${a}.zip; 
    fi 
done

for LOC in ul ur ll lr; do 
    zip -1 -q final/ELEV_NE.zip `sqlite3 maps.elv.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} >= -85) and (level != ' 4') and name like '%elev48w%';"`
    sqlite3 maps.elv.db    		    "update files set info='ELEV_NE' where (latc >= 38) and (lonc >= -85) and name like '%elev48w%';"

    zip -1 -q final/ELEV_NC.zip `sqlite3 maps.elv.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and (level != ' 4') and name like '%elev48w%';"`
    sqlite3 maps.elv.db 		    "update files set info='ELEV_NC' where (latc >= 38) and (lonc <= -85) and (lonc >= -110) and name like '%elev48w%';"

    zip -1 -q final/ELEV_NW.zip `sqlite3 maps.elv.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} <= -110) and (level != ' 4') and name like '%elev48w%';"`
    sqlite3 maps.elv.db 		    "update files set info='ELEV_NW' where (latc >= 38) and (lonc <= -110) and name like '%elev48w%';"

    zip -1 -q final/ELEV_SE.zip `sqlite3 maps.elv.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} >= -85) and (level != ' 4') and name like '%elev48w%';"`
    sqlite3 maps.elv.db 		    "update files set info='ELEV_SE' where (latc <= 38) and (lonc >= -85) and name like '%elev48w%';"

    zip -1 -q final/ELEV_SC.zip `sqlite3 maps.elv.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and (level != ' 4') and name like '%elev48w%';"`
    sqlite3 maps.elv.db 		    "update files set info='ELEV_SC' where (latc <= 38) and (lonc <= -85) and (lonc >= -110) and name like '%elev48w%';"

    zip -1 -q final/ELEV_SW.zip `sqlite3 maps.elv.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} <= -110) and (level != ' 4') and name like '%elev48w%';"`
    sqlite3 maps.elv.db 		    "update files set info='ELEV_SW' where (latc <= 38) and (lonc <= -110) and name like '%elev48w%';"
done

zip -1 -q final/ELEV_AK.zip `sqlite3 maps.elv.db "select name from files where name like '%elevakw%';"`
sqlite3 maps.elv.db 		    "update files set info='ELEV_AK' where name like '%elevakw%';"

zip -1 -q final/ELEV_PR.zip `sqlite3 maps.elv.db "select name from files where name like '%elevprw%';"`
sqlite3 maps.elv.db 		    "update files set info='ELEV_PR' where name like '%elevprw%';"

zip -1 -q final/ELEV_HI.zip `sqlite3 maps.elv.db "select name from files where name like '%elevhiw%';"`
sqlite3 maps.elv.db 		    "update files set info='ELEV_HI' where name like '%elevhiw%';"
