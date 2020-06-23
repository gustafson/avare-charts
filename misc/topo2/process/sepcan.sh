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
 
rm -rf final
mkdir final

name=CAN_010
latu=44
latd=40
lonr=-56
lonl=-64

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_020
latu=44
latd=40
lonr=-64
lonl=-72

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_030
latu=44
latd=40
lonr=-72
lonl=-80

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_040
latu=44
latd=40
lonr=-80
lonl=-88

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_001
latu=48
latd=44
lonr=-48
lonl=-56

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_011
latu=48
latd=44
lonr=-56
lonl=-64

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_021
latu=48
latd=44
lonr=-64
lonl=-72

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_031
latu=48
latd=44
lonr=-72
lonl=-80

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_041
latu=48
latd=44
lonr=-80
lonl=-88

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_002
latu=52
latd=48
lonr=-48
lonl=-56

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_012
latu=52
latd=48
lonr=-56
lonl=-64

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_022
latu=52
latd=48
lonr=-64
lonl=-72

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_032
latu=52
latd=48
lonr=-72
lonl=-80

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_042
latu=52
latd=48
lonr=-80
lonl=-88

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_052
latu=52
latd=48
lonr=-88
lonl=-96

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_062
latu=52
latd=48
lonr=-96
lonl=-104

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_072
latu=52
latd=48
lonr=-104
lonl=-112

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_082
latu=52
latd=48
lonr=-112
lonl=-120

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_092
latu=52
latd=48
lonr=-120
lonl=-128

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_102
latu=52
latd=48
lonr=-128
lonl=-136

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_003
latu=56
latd=52
lonr=-48
lonl=-56

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_013
latu=56
latd=52
lonr=-56
lonl=-64

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_023
latu=56
latd=52
lonr=-64
lonl=-72

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_033
latu=56
latd=52
lonr=-72
lonl=-80

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_043
latu=56
latd=52
lonr=-80
lonl=-88

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_053
latu=56
latd=52
lonr=-88
lonl=-96

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_063
latu=56
latd=52
lonr=-96
lonl=-104

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_073
latu=56
latd=52
lonr=-104
lonl=-112

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_083
latu=56
latd=52
lonr=-112
lonl=-120

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_093
latu=56
latd=52
lonr=-120
lonl=-128

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_103
latu=56
latd=52
lonr=-128
lonl=-136

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_014
latu=60
latd=56
lonr=-56
lonl=-64

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_024
latu=60
latd=56
lonr=-64
lonl=-72

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_034
latu=60
latd=56
lonr=-72
lonl=-80

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_044
latu=60
latd=56
lonr=-80
lonl=-88

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_054
latu=60
latd=56
lonr=-88
lonl=-96

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_064
latu=60
latd=56
lonr=-96
lonl=-104

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_074
latu=60
latd=56
lonr=-104
lonl=-112

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_084
latu=60
latd=56
lonr=-112
lonl=-120

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_094
latu=60
latd=56
lonr=-120
lonl=-128

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_104
latu=60
latd=56
lonr=-128
lonl=-136

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"

name=CAN_114
latu=60
latd=56
lonr=-136
lonl=-144

zip -1 -q final/${name}.zip `sqlite3 maps.db "select name from files where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"`
sqlite3 maps.db    		    "update files set info='${name}' where (latc<=${latu}) and (latc>=${latd}) and (lonc<=${lonr}) and (lonc>=${lonl});"
