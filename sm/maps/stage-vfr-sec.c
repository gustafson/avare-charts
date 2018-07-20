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

int debug=0;
#include "charts.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char *n_ptr;
  char *dir_ptr;

  char buffer[512];
  char filestr[512];
  char cmdstr[4096];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:900913' ");

    if (argc>=2){debug=1;}

  out("rm -fr merge/sec; mkdir -p merge/sec"); // Alaska sec
  out("rm -fr merge/wac; mkdir -p merge/wac"); // WAC Alaska
  int entries = sizeof(maps) / sizeof(maps[0]);

  for(map = 0; map < entries; map++)
    {
      n_ptr = maps[map].name; 
      // Blank the cmdstr
      snprintf(cmdstr, sizeof(cmdstr), "");
  
      printf("\n\n\n#%s\n", maps[map].name);
 
      if(0 == strcmp(maps[map].reg, "WC") || (0 == strcmp(maps[map].reg, "WA"))) {
	dir_ptr = "wac";
      }
      else {
	dir_ptr = "sec";
      }
      // Establish a parallel safe tmp name
      snprintf(filestr, sizeof(filestr), "merge/%s/%02i%s", dir_ptr, map, maps[map].name);
 
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -expand rgb -srcwin %i %i %i %i charts/%s/%s*.tif %s_1.vrt;\n",
	       maps[map].x, maps[map].y, maps[map].dx, maps[map].dy, dir_ptr, n_ptr, filestr);
      strcat(cmdstr, buffer);
      // Put a mask near the edges so that no seams show on the tiles
      snprintf(buffer, sizeof(buffer),
	       // Note the reversed order 2, 1 is appropriate
	       "gdalbuildvrt -r cubicspline -addalpha -srcnodata '0 0 0' -srcnodata '255 255 255' %s_2.vrt  %s_1.vrt;\n", filestr, filestr);
      strcat(cmdstr, buffer);
      snprintf(buffer, sizeof(buffer),
	       // "gdalwarp -tr 43.684681955566703 43.684681955566703 -of vrt -r cubicspline %s %s_2.vrt %s_3.vrt;\n",
	       "gdalwarp -tr 43 43 -of vrt -r cubicspline %s %s_2.vrt %s_3.vrt;\n",
	       // "gdalwarp -of vrt -r cubicspline %s %s_2.vrt %s_3.vrt;\n",
	       projstr, filestr, filestr);
      strcat(cmdstr, buffer);
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -projwin_srs WGS84 -projwin %f %f %f %f %s_3.vrt %s_c.vrt;\n",
	       maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
	       filestr, filestr);
      strcat(cmdstr, buffer);
      out (cmdstr);
    }
  
  printf("\n\n\n");

  snprintf(filestr, sizeof(filestr), "gdalbuildvrt -r cubicspline -resolution highest -overwrite");
  // for(map = 0; map < 2; map++)
  //   {
  //     if (map==0){
	snprintf(buffer, sizeof(buffer), "%s sec.vrt merge/sec/*_c.vrt", filestr);
  //     } else if (map==1){
  // 	snprintf(buffer, sizeof(buffer), "%s wac.vrt merge/wac/*_c.vrt", filestr);
  //     }
      out(buffer);
  //  }
  
  printf("\n\n\n");
  return 0;
}

