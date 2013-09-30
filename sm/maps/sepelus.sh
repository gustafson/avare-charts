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
 

zip -1 -q final/ELUS_NE.zip `sqlite3 maps.el.db "select name from files where (latc >= 38) and (lonc >= -85) and name like '%tiles/ifr/el%';"`
sqlite3 maps.el.db    		    "update files set info='ELUS_NE' where (latc >= 38) and (lonc >= -85) and name like '%tiles/ifr/el%';"

zip -1 -q final/ELUS_NC.zip `sqlite3 maps.el.db "select name from files where (latc >= 38) and (lonc <= -85) and (lonc >= -110) and name like '%tiles/ifr/el%';"`
sqlite3 maps.el.db 		    "update files set info='ELUS_NC' where (latc >= 38) and (lonc <= -85) and (lonc >= -110) and name like '%tiles/ifr/el%';"

zip -1 -q final/ELUS_NW.zip `sqlite3 maps.el.db "select name from files where (latc >= 38) and (lonc <= -110) and name like '%tiles/ifr/el%';"`
sqlite3 maps.el.db 		    "update files set info='ELUS_NW' where (latc >= 38) and (lonc <= -110) and name like '%tiles/ifr/el%';"

zip -1 -q final/ELUS_SE.zip `sqlite3 maps.el.db "select name from files where (latc <= 38) and (lonc >= -85) and name like '%tiles/ifr/el%';"`
sqlite3 maps.el.db 		    "update files set info='ELUS_SE' where (latc <= 38) and (lonc >= -85) and name like '%tiles/ifr/el%';"

zip -1 -q final/ELUS_SC.zip `sqlite3 maps.el.db "select name from files where (latc <= 38) and (lonc <= -85) and (lonc >= -110) and name like '%tiles/ifr/el%';"`
sqlite3 maps.el.db 		    "update files set info='ELUS_SC' where (latc <= 38) and (lonc <= -85) and (lonc >= -110) and name like '%tiles/ifr/el%';"

zip -1 -q final/ELUS_SW.zip `sqlite3 maps.el.db "select name from files where (latc <= 38) and (lonc <= -110) and name like '%tiles/ifr/el%';"`
sqlite3 maps.el.db 		    "update files set info='ELUS_SW' where (latc <= 38) and (lonc <= -110) and name like '%tiles/ifr/el%';"

