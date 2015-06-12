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
  int failed;
  int count;

  char buffer[512];
  char filestr[512];
  char cmdstr[4096];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:900913' ");

    if (argc>=2){debug=1;}

  out("rm -fr merge/AK; mkdir -p merge/AK/QC"); // Alaska sec
  out("rm -fr merge/LF; mkdir -p merge/LF/QC"); // lower 48 sec
  out("rm -fr merge/HI; mkdir -p merge/HI/QC"); // HI sec
  out("rm -fr merge/WC; mkdir -p merge/WC/QC"); // WAC
  out("rm -fr merge/WA; mkdir -p merge/WA/QC"); // WAC Alaska
  out("rm -fr tmp-stagesec; mkdir tmp-stagesec"); 

  int entries = sizeof(maps) / sizeof(maps[0]);

  out("rm -f sec-ak.tif");
  out("rm -f sec-hi.tif");
  out("rm -f sec-48.tif");
  out("rm -f wac-48.tif");
  out("rm -f sec-ak_small.jpg");
  out("rm -f sec-hi_small.jpg");
  out("rm -f sec-48_small.jpg");
  out("rm -f wac-48_small.jpg");

#pragma omp parallel for private(n_ptr, dir_ptr, failed, count, buffer, filestr, cmdstr) schedule(dynamic,1)
  for(map = 0; map < entries; map++)
    {
      n_ptr = maps[map].name; 
      // Establish a parallel safe tmp name
      snprintf(filestr, sizeof(filestr), "merge/%s/%s", maps[map].reg, maps[map].name);
      // Blank the cmdstr
      snprintf(cmdstr, sizeof(cmdstr), "");
  
      printf("\n\n\n#%s\n", maps[map].name);
 
      if(0 == strcmp(maps[map].reg, "WC") || (0 == strcmp(maps[map].reg, "WA"))) {
	dir_ptr = "wac";
      }
      else {
	dir_ptr = "sec";
      }
 
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -expand rgb -srcwin %i %i %i %i charts/%s/%s*.tif %s_1.vrt;\n",
	       maps[map].x, maps[map].y, maps[map].dx, maps[map].dy, dir_ptr, n_ptr, filestr);
      strcat(cmdstr, buffer);
      // Put a mask near the edges so that no seams show on the tiles
      snprintf(buffer, sizeof(buffer),
	       // Note the reversed order 2, 1 is appropriate
	       "gdalbuildvrt -addalpha -srcnodata '0 0 0' -srcnodata '255 255 255' %s_2.vrt  %s_1.vrt;\n", filestr, filestr);
      strcat(cmdstr, buffer);
      snprintf(buffer, sizeof(buffer),
	       "gdalwarp -of vrt --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline %s %s_2.vrt %s_3.vrt;\n",
	       projstr, filestr, filestr, filestr);
      strcat(cmdstr, buffer);
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -projwin_srs WGS84 -projwin %f %f %f %f %s_3.vrt %s_c.vrt;\n",
	       maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
	       filestr, filestr);
      strcat(cmdstr, buffer);
      failed = 1;
      count = 0;
      out (cmdstr);
    }
  
  printf("\n\n\n");

  snprintf(filestr, sizeof(filestr), "gdalbuildvrt -resolution highest -overwrite");
#pragma omp parallel num_threads(2) private (buffer)
  {
    map = omp_get_thread_num();
    if (map==0){
      snprintf(buffer, sizeof(buffer), "%s sec-all.vrt merge/LF/*_c.vrt merge/AK/*_c.vrt merge/HI/*_c.vrt ", filestr);
    } else if (map==1){
      snprintf(buffer, sizeof(buffer), "%s wac-all.vrt merge/WC/*_c.vrt merge/WA/*_c.vrt", filestr);
    }
    out(buffer);
  }

  printf("\n\n\n");
  return 0;
}

