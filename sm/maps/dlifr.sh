#!/bin/bash
#Copyright (c) 2012, Zubair Khan (governer@gmail.com) 
#Copyright (c) 2015, Peter A. Gustafson (peter.gustafson@wmich.edu)
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

export DT=$1

pushd charts/iff
for ch in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36;do
    wget http://aeronav.faa.gov/enroute/${DT,,}/enr_l$ch.zip
done
popd

## IFR low Alaska
pushd charts/ifal
for ch in 1 2 3 4; do
    ## Alaska low
    wget http://aeronav.faa.gov/enroute/${DT,,}/enr_akl0$ch.zip
done
popd

pushd charts/ifal
for ch in 1 2; do
    ## Hawaii Pacific
    wget http://aeronav.faa.gov/enroute/${DT,,}/enr_p0$ch.zip
done
popd

## IFR area
pushd charts/ifa
for ch in 1 2; do
    wget http://aeronav.faa.gov/enroute/${DT,,}/enr_a0$ch.zip
done
popd

## IFR 48 High
pushd charts/ifh;
for ch in 01 02 03 04 05 06 07 08 09 10 11; do
    wget http://aeronav.faa.gov/enroute/${DT,,}/enr_h$ch.zip
done
popd

## Alaska high
pushd charts/ifah
for ch in 1 2; do
    wget http://aeronav.faa.gov/enroute/${DT,,}/enr_akh0$ch.zip
done
popd
