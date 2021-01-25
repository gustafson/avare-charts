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

## Are we replacing version.php or planning for the next cycle

CURRENT=False
if (len(sys.argv) > 1):
    if (sys.argv[1] == "version.php"):
        CURRENT=True


## Set the time zone to UTC
UTC = datetime.timezone(offset=datetime.timedelta(0))

refdate = datetime.datetime(2015, 8, 20, 9, 1, tzinfo=UTC)
now = datetime.datetime.now(tz=UTC)

## 28 days cycles, how far forward does the next start
daysInFuture = ((refdate-now).days)%28

## If we are writing current cycle to version.php, use the date
## associated with the last change
if CURRENT:
    daysInFuture -= 28

cycleDate = now+datetime.timedelta(days=daysInFuture)

## Days since the start of the year
daysinYear = (cycleDate-datetime.datetime(cycleDate.year, 1, 1, 0, 0, tzinfo=UTC))

## Determine the next cyclenumberimport math
import math
cyclenumber = math.floor(daysinYear.days/28)+1
cyclestr = ("%s%02d"  % (cycleDate.strftime("%y"), cyclenumber))

if CURRENT:
    print('<?php echo "%s";?>' % cyclestr)
else:
    print(cyclestr)
