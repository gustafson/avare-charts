#!/bin/bash
#Copyright (c) 2014, Apps4av Inc. (apps4av@gmail.com) 
# Author: Peter A. Gustafson (peter.gustafson@wmich.edu)
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


if [[ $# -eq 0 ]]; then
    echo argument required
    exit 
fi

CYCLEDAYS=$1
if [[ $2 = dof ]]; then
    REF=`date -u -d 3/2/2014 +%s`
    CYCLEDAYS=56
else
    REF=`date -u -d 12/12/2013 +%s`
fi

# TODAY="4/1/2014"
TODAY="today"
TOD=`date -u -d ${TODAY} +%s`

if [[ ${CYCLEDAYS} -eq 56 ]]; then
    SREF=$(( ($TOD-$REF)/86400%56 ))
    SREF=$((56-$SREF))
elif [[ ${CYCLEDAYS} -eq 28 ]]; then
    SREF=$(( ($TOD-$REF)/86400%28 ))
    SREF=$((28-$SREF))
fi

## If more than a week in the future, pick the last date
if [[ $SREF -gt 7 ]]; then
    SREF=$(($SREF-${CYCLEDAYS}))
fi

if [[ $2 = ifr ]]; then
    echo `date -d "$TODAY + $SREF days" +"%^m-%d-%Y"`
elif [[ $2 = base ]]; then
    echo `date -d "$TODAY + $SREF days" +"%Y-%^m-%d"`
elif [[ $2 = dof ]]; then
    echo `date -d "$TODAY + $SREF days" +"%y%^m%d"`
else
    echo `date -d "$TODAY + $SREF days" +"%d%^b%Y"`
fi
