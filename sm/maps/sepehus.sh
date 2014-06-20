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

ZIP=zip
SQL=sqlite3

if [[ $# -gt 1 ]]; then
    echo Debug mode
    ZIP="echo zip"
    SQL="echo sqlite3"
fi
    
CYCLE=$1

for a in NE NC NW SE SC SW AK; do
    if [[ -f final/EHUS_${a}.zip ]]; then
        rm final/EHUS_${a}.zip;
    fi
done

for LOC in ul ur ll lr c; do #
    ${ZIP} -9 -q final/EHUS_NE.zip `${SQL} maps.eh.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} >= -85) and (level != '4') and name like '%tiles/${CYCLE}/ifh/48%';"`
    ${SQL} maps.eh.db    		    "update files set info='EHUS_NE' where (lat${LOC} >= 38) and (lon${LOC} >= -85) and name like '%tiles/${CYCLE}/ifh/48%';"

    ${ZIP} -9 -q final/EHUS_NC.zip `${SQL} maps.eh.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and (level != '4') and name like '%tiles/${CYCLE}/ifh/48%';"`
    ${SQL} maps.eh.db 		    "update files set info='EHUS_NC' where (lat${LOC} >= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and name like '%tiles/${CYCLE}/ifh/48%';"

    ${ZIP} -9 -q final/EHUS_NW.zip `${SQL} maps.eh.db "select name from files where (lat${LOC} >= 38) and (lon${LOC} <= -110) and (level != '4') and name like '%tiles/${CYCLE}/ifh/48%';"`
    ${SQL} maps.eh.db 		    "update files set info='EHUS_NW' where (lat${LOC} >= 38) and (lon${LOC} <= -110) and name like '%tiles/${CYCLE}/ifh/48%';"

    ${ZIP} -9 -q final/EHUS_SE.zip `${SQL} maps.eh.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} >= -85) and (level != '4') and name like '%tiles/${CYCLE}/ifh/48%';"`
    ${SQL} maps.eh.db 		    "update files set info='EHUS_SE' where (lat${LOC} <= 38) and (lon${LOC} >= -85) and name like '%tiles/${CYCLE}/ifh/48%';"

    ${ZIP} -9 -q final/EHUS_SC.zip `${SQL} maps.eh.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and (level != '4') and name like '%tiles/${CYCLE}/ifh/48%';"`
    ${SQL} maps.eh.db 		    "update files set info='EHUS_SC' where (lat${LOC} <= 38) and (lon${LOC} <= -85) and (lon${LOC} >= -110) and name like '%tiles/${CYCLE}/ifh/48%';"

    ${ZIP} -9 -q final/EHUS_SW.zip `${SQL} maps.eh.db "select name from files where (lat${LOC} <= 38) and (lon${LOC} <= -110) and (level != '4') and name like '%tiles/${CYCLE}/ifh/48%';"`
    ${SQL} maps.eh.db 		    "update files set info='EHUS_SW' where (lat${LOC} <= 38) and (lon${LOC} <= -110) and name like '%tiles/${CYCLE}/ifh/48%';"
done

${ZIP} -9 -q final/EHUS_AK.zip `${SQL} maps.eh.db "select name from files where (level != '4') and name like '%tiles/${CYCLE}/ifh/ak%';"`
${SQL} maps.eh.db 		    "update files set info='EHUS_AK' where name like '%tiles/${CYCLE}/ifh/ak%';"
