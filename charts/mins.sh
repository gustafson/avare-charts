#!/bin/bash
# Copyright (c) 2012, Zubair Khan (governer@gmail.com) 
# Copyright (c) 2020, Peter Gustafson (peter.gustafson@wmich.edu)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#
#    * Redistributions of source code must retain the above copyright
#    * notice, this list of conditions and the following disclaimer.
#
#    * Redistributions in binary form must reproduce the above
#    * copyright notice, this list of conditions and the following
#    * disclaimer in the documentation and/or other materials provided
#    * with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
 
# Download and run on ALTERNATE and TAKEOFF minimums
# e.g. mins.sh NE1TO
# e.g. mins.sh NEIALT
# Use mogrify to convert PDF to images with names like NE1TO-0.jpeg ...

export PG=`pdfinfo $1.PDF | grep Pages | sed "s/Pages:\s*//"`

## Split by column and combine into one text file.  This is done on a per pdf basis
for (( c=1; c<=${PG}; c++ )); do
    pdftotext -f $c -l $c -nopgbrk -W 194 -x 0 -H 594 -y 0 $1.PDF tmp1.txt
    pdftotext -f $c -l $c -nopgbrk -W 194 -x 194 -H 594 -y 0 $1.PDF tmp2.txt
    cat tmp1.txt > tmp.txt
    cat tmp2.txt >> tmp.txt
    ../mins.pl $1 `expr $c - 1`
done
