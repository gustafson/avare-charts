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
 
#cp -ard ../usgs/sr/tiles/6 tiles

for a in NE NC NW SE SC SW AK PR HI; do
    if [[ -f final/REL_${a}.zip ]]; then
        rm final/REL_${a}.zip;
    fi
done

zip -1 -q final/REL_NE.zip `sqlite3 maps.rel.db "select name from files where (latc >= 38) and (lonc >= -85) and (level != ' 4') and name like '%rel48w%';"`
sqlite3 maps.rel.db    		    "update files set info='REL_NE' where (latc >= 38) and (lonc >= -85) and name like '%rel48w%';"

zip -1 -q final/REL_NC.zip `sqlite3 maps.rel.db "select name from files where (latc >= 38) and (lonc <= -85) and (lonc >= -110) and (level != ' 4') and name like '%rel48w%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_NC' where (latc >= 38) and (lonc <= -85) and (lonc >= -110) and name like '%rel48w%';"

zip -1 -q final/REL_NW.zip `sqlite3 maps.rel.db "select name from files where (latc >= 38) and (lonc <= -110) and (level != ' 4') and name like '%rel48w%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_NW' where (latc >= 38) and (lonc <= -110) and name like '%rel48w%';"

zip -1 -q final/REL_SE.zip `sqlite3 maps.rel.db "select name from files where (latc <= 38) and (lonc >= -85) and (level != ' 4') and name like '%rel48w%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_SE' where (latc <= 38) and (lonc >= -85) and name like '%rel48w%';"

zip -1 -q final/REL_SC.zip `sqlite3 maps.rel.db "select name from files where (latc <= 38) and (lonc <= -85) and (lonc >= -110) and (level != ' 4') and name like '%rel48w%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_SC' where (latc <= 38) and (lonc <= -85) and (lonc >= -110) and name like '%rel48w%';"

zip -1 -q final/REL_SW.zip `sqlite3 maps.rel.db "select name from files where (latc <= 38) and (lonc <= -110) and (level != ' 4') and name like '%rel48w%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_SW' where (latc <= 38) and (lonc <= -110) and name like '%rel48w%';"

zip -1 -q final/REL_AK.zip `sqlite3 maps.rel.db "select name from files where name like '%relakw%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_AK' where name like '%relakw%';"

zip -1 -q final/REL_PR.zip `sqlite3 maps.rel.db "select name from files where name like '%relprw%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_PR' where name like '%relprw%';"

zip -1 -q final/REL_HI.zip `sqlite3 maps.rel.db "select name from files where name like '%relhiw%';"`
sqlite3 maps.rel.db 		    "update files set info='REL_HI' where name like '%relhiw%';"
