#!/bin/bash
#Copyright (c) 2014-16, Apps4av Inc. (apps4av@gmail.com) 
# Author: Peter A. Gustafson (peter.gustafson@wmich.edu)
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions
#are met:
#
#    * Redistributions of source code must retain the above copyright
#    * notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#    * copyright notice, this list of conditions and the following
#    * disclaimer in the documentation and/or other materials provided
#    * with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
#INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
#OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
#AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
#WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#POSSIBILITY OF SUCH DAMAGE.
#


if [[ $# -eq 0 ]]; then
    echo Length of cycle required as argument \(28 or 56\)
    exit 
fi

CYCLEDAYS=$1
if [[ $2 = dof ]]; then
    REF=`date -u -d 12/8/2014 +%s`
    ## CYCLEDAYS=56 ## Updated no longer every 56 days as of 4/27/2017
else
    REF=`date -u -d 8/20/2015 +%s`
fi

#TODAY="7/15/2014"
TODAY=`date -u -d "today 00:00:00" +%x`
TOD=`date -u -d "${TODAY}" +%s`

if [[ ${CYCLEDAYS} -eq 56 ]]; then
    SREF=$(( ($TOD-$REF)/86400%56 ))
    SREF=$((56-$SREF))
elif [[ ${CYCLEDAYS} -eq 28 ]]; then
    SREF=$(( ($TOD-$REF)/86400%28 ))
    SREF=$((28-$SREF))
else
    echo Length of cycle required as argument \(28 or 56\)
    exit
fi


## If within 1 day of the prior cycle, choose it instead.
if [[ $SREF -gt 27 ]]; then
    SREF=$(($SREF-${CYCLEDAYS}))
fi

if [[ $# -eq 3 ]]; then
    ## For stageall.sh use only
    if [[ $2 = ifr ]]; then
	if [[ $SREF -le 0 ]]; then
	    echo none
	else
	    echo ifr
	fi
    elif [[ $2 = vfr ]]; then
	echo vfr
    fi
    exit 
fi

if [[ $2 = ifr ]]; then
    echo `date -d "$TODAY + $SREF days" +"%^m-%d-%Y"`
elif [[ $2 = base ]]; then
    echo `date -d "$TODAY + $SREF days" +"%Y-%^m-%d"`
elif [[ $2 = dof ]]; then  ## Obstacle file
    echo `date -d "$TODAY + $SREF days" +"%y%^m%d"`
elif [[ $2 = afd ]]; then 
    echo `date -d "$TODAY + $SREF days" +"%Y%^m%d"`
elif [[ $2 = plates ]]; then 
    echo `date -d "$TODAY + $SREF days" +"%y%^m%d"`
elif [[ $2 = canada ]]; then 
    echo `date -d "$TODAY + $SREF days" +"%y-%^m-%d"`
elif [[ $2 = lastcycle ]]; then

    if [[ ${CYCLEDAYS} -eq 28 ]]; then
	SREF=$(($SREF-28))
    fi
    echo `date -d "$TODAY + $SREF days" +"%d%^b%Y"`

else
    echo `date -d "$TODAY + $SREF days" +"%d%^b%Y"`
fi
