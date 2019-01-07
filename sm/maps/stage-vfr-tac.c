/*
# Copyright (c) 2012, Zubair Khan (governer@gmail.com)
# Copyright (c) 2013, Peter A. Gustafson (peter.gustafson@wmich.edu)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
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
*/

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct {
  char name[64];
  double lonl;
  double lonr;
  double latu;
  double latd;
  char   reg[64];
} Maps;

int debug=0;
#include "chartstac.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char filestr[512];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:3857' ");
  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/tac");
  out("mkdir -p merge/tac"); // TAC
  int entries = sizeof(maps) / sizeof(maps[0]);

  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(filestr, sizeof(filestr), "merge/tac/%s%s", maps[map].reg, maps[map].name);

    printf("\n\n# %s\n", maps[map].name);

    dir_ptr = "tac";
    
    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/%s/%s*.tif|grep -vi planning | tail -n1` %s_1.vrt",
	     dir_ptr, n_ptr, filestr);
    out(buffer);

    snprintf(buffer, sizeof(buffer), "gdalwarp -of vrt -r cubicspline -dstnodata 51 %s %s_1.vrt %s_2.vrt", projstr, filestr, filestr);
    out(buffer);
    
    snprintf(buffer, sizeof(buffer),
    	     "gdal_translate -of vrt -r cubicspline -a_nodata 51 -q -projwin_srs WGS84 -projwin %f %f %f %f %s_2.vrt %s_c.vrt",
    	     maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
    	     filestr, filestr);
    out(buffer);
  }

  out ("\n\n\n");
  out ("sleep 10\n\n\n");
  
//  out ("pushd merge/tac; gdalbuildvrt -r cubicspline -srcnodata '0 0 0' -vrtnodata '0 0 0' -resolution highest runtacgroup_1_c.vrt -overwrite T1*_c.vrt; popd");
//  out ("pushd merge/tac; gdalbuildvrt -r cubicspline -srcnodata '0 0 0' -vrtnodata '0 0 0' -resolution highest runtacgroup_2_c.vrt -overwrite T2*_c.vrt; popd");
//  out ("pushd merge/tac; gdalbuildvrt -r cubicspline -srcnodata '0 0 0' -vrtnodata '0 0 0' -resolution highest runtacgroup_c_c.vrt -overwrite T3*_c.vrt; popd");
//  out ("pushd merge/tac; gdalbuildvrt -r cubicspline -srcnodata '0 0 0' -vrtnodata '0 0 0' -resolution highest runtacgroup_4_c.vrt -overwrite T4*_c.vrt; popd");
//  out ("pushd merge/tac; gdalbuildvrt -r cubicspline -srcnodata '0 0 0' -vrtnodata '0 0 0' -resolution highest runtacgroup_5_c.vrt -overwrite T5*_c.vrt; popd");
  out ("gdalbuildvrt -r cubicspline -srcnodata 51 -vrtnodata 51 -resolution highest tac.vrt -overwrite merge/tac/run*c.vrt");
  return 0;
}
