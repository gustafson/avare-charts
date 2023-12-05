#!/usr/bin/python

## Copyright (c) 2020, Apps4av Inc.
## *   Author: Peter A. Gustafson (peter.gustafson@wmich.edu)
## *   All rights reserved.
## 
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are
## met:
## 
## *   Redistributions of source code must retain the above copyright
## 	notice, this list of conditions and the following disclaimer.
## *   Redistributions in binary form must reproduce the above copyright
## 	notice, this list of conditions and the following disclaimer in
## 	the documentation and/or other materials provided with the
## 	distribution.
## 
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
## LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
## A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
## LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
## DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
## THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import datetime
import sys

import argparse
parser = argparse.ArgumentParser(
    prog='cyclenumber.py',
    description='Choose the cycle number for Avare charts',
    epilog='Copyright 2023 Peter A. Gustafson')

## Are we replacing version.php or planning for the next cycle
parser.add_argument('-v', '--version', action='store_true')
## Are we replacing version.php or planning for the next cycle
parser.add_argument('-c', '--current', action='store_true')
## Are we deleting an old cycle
parser.add_argument('-o', '--old', action='store_true')

## Parse the args
args = parser.parse_args()

## Set the time zone to UTC
UTC = datetime.timezone(offset=datetime.timedelta(0))

## Set the reference date and now
refdate = datetime.datetime(2015, 8, 20, 9, 1, tzinfo=UTC)
now = datetime.datetime.now(tz=UTC)

## 28 days cycles, how far forward does the next start
daysInFuture = ((refdate-now).days)%28

## If we are writing current cycle to version.php, use the date
## associated with the last change
if args.current:
    daysInFuture -= 28

## Identify the cycle change
cycleDate = now+datetime.timedelta(days=daysInFuture)

## Track days since the start of the year in the cycle
daysinYear = (cycleDate-datetime.datetime(cycleDate.year, 1, 1, 0, 0, tzinfo=UTC))

## Determine the next cyclenumber
import math
cyclenumber = math.floor(daysinYear.days/28)+1

if args.old:
    cyclenumber -= 1

cyclestr = ("%s%02d"  % (cycleDate.strftime("%y"), cyclenumber))

if args.version:
    print(f'<?php echo "{cyclestr}";?>')
else:
    print(cyclestr)
