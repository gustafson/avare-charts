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
#include "chartsifa.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[512];
  // char tmpstr2[512];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:900913' ");
  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/ifa; mkdir merge/ifa;"); // ifa
  // out("rm -fr merge/ifa-temp; mkdir merge/ifa-temp;"); // ifa
  int entries = sizeof(maps) / sizeof(maps[0]);
  
  for(map = 0; map < entries; map++) {
    if(0 == strcmp(maps[map].reg, "IFA")) {
      dir_ptr = "ifa";
    } else if(0 == strcmp(maps[map].reg, "IFAL")) {
      dir_ptr = "ifal";
    } else {
      dir_ptr = "empty";
    }
 
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "merge/ifa/%s", maps[map].name);
    //snprintf(tmpstr2, sizeof(tmpstr2), "merge/ifa-temp/%s", maps[map].name);

    printf("\n\n# %s\n", maps[map].name);

    snprintf(buffer, sizeof(buffer),
	     "gdalwarp -of vrt %s charts/%s/%s.tif %s.vrt",
	     projstr, dir_ptr, n_ptr, tmpstr);
    out(buffer);

    // snprintf(buffer, sizeof(buffer),
    // 	     "gdalwarp -tr 30 30 -of vrt %s charts/%s/%s.tif %s.vrt",
    // 	     projstr, dir_ptr, n_ptr, tmpstr2);
    // out(buffer);

  }

  /* one image */
  out("\n\n\n# Merge all");
  out("gdalbuildvrt -resolution highest ifa.vrt -overwrite `ls merge/ifa/*.vrt|grep -v GUA`\n");

  return 0;
}
