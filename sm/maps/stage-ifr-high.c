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
  int x;
  int y;
  int sizex;
  int sizey;
  char reg[64];
} Maps;

int debug=0;
#include "chartsifh.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[512];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:900913' ");
  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/ifh; mkdir -p merge/ifh");

  int entries = sizeof(maps) / sizeof(maps[0]);

  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    printf("\n\n# %s\n\n", maps[map].name);

    if(0 == strcmp(maps[map].reg, "IFH")) {
      dir_ptr = "ifr";
    }else if(0 == strcmp(maps[map].reg, "IFAH")) {
      dir_ptr = "ifr";
    }else if(0 == strcmp(maps[map].reg, "IFAL")) {
      dir_ptr = "ifr";
    }else{
      dir_ptr = "ifr";
    }

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "merge/ifh/%02i%s", map, maps[map].name);
    
    if((0 == strcmp(maps[map].reg, "IFH")) ||
       (0 == strcmp(maps[map].reg, "IFAL")) ||
       (0 == strcmp(maps[map].reg, "IFAH"))) {
			
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r lanczos -a_nodata '51 51 51' -srcwin %d %d %d %d charts/%s/%s.tif %s_1.vrt",
	       maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	       dir_ptr, n_ptr, tmpstr);
      out(buffer);
      
      snprintf(buffer, sizeof(buffer),  
      	       "gdalwarp -of vrt -r lanczos -dstnodata '51 51 51' %s %s_1.vrt %s_2.vrt\n",
      	       projstr, tmpstr, tmpstr);
      out(buffer);

    }
  }
  
  /* one image */
  out("\n\n\n# Merge all");
  // The pacific should be first, so it is underneath
  out("gdalbuildvrt -r lanczos -resolution highest ifh.vrt -overwrite merge/ifh/*_2.vrt\n");

  return 0;
}
