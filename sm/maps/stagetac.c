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
  char tmpstr[512];
  char mbuffer[4096];
  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/TC; mkdir merge/TC"); // TAC
  out("[[ -d tmp-stagetac ]] && rm -fr tmp-stagetac");
  out("mkdir tmp-stagetac");
  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, dir_ptr, buffer, tmpstr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "tmp-stagetac/tmpstagetac%i", map);

    printf("\n\n# %s\n", maps[map].name);

    dir_ptr = "tac";
    // snprintf(buffer, sizeof(buffer),
    // 	     "cp `ls charts/%s/%s*.tif|tail -n1` %s",
    // 	     dir_ptr, n_ptr, tmpstr);
    // out(buffer);

    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -expand rgb `ls charts/%s/%s*.tif|tail -n1` %s.tif",
	     dir_ptr, n_ptr, tmpstr);
    out(buffer);

    snprintf(buffer, sizeof(buffer),
	     "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -q -r cubicspline -t_srs WGS84 %s.tif %s_w.tif",
	     tmpstr, tmpstr);
    out(buffer);
		
    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -q -projwin %f %f %f %f  %s_w.tif merge/%s/%s.tif",
	     maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
	     tmpstr,
	     "TC",
	     n_ptr);
    out(buffer);

    snprintf(buffer, sizeof(buffer), "rm -f %s.tif %s_w.tif", tmpstr, tmpstr);
    out(buffer);

  }

  printf("\n\n\n");
  // out("rm -fr tiles_tac tac.tif; mkdir tiles_tac");
  // printf("\n\n\n");

  int gdw=0;
  if (gdw){
    sprintf(mbuffer, "gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 ");
  }else{
    sprintf(mbuffer, "gdal_merge.py -o tac.tif ");
  }
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    if(0 == strcmp(maps[map].reg, "TS")) {
      // Don't include the separate TACs (in Alaska and Puerto Rico) in the continental US chart
      // snprintf(buffer, sizeof(buffer),
      // 	       "gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir tiles_tac -ps 512 512 -useDirForEachRow merge/TC/%s.tif", n_ptr);
      // printf("#retiling %s\n", n_ptr);
      // out(buffer);
    }
    else {
      snprintf(buffer, sizeof(buffer), "merge/TC/%s.tif ", n_ptr);
      strcat(mbuffer, buffer);
    }
  }

  // Use this if using gdalwarp above, otherwise no
  if (gdw){
    snprintf(buffer, sizeof(buffer), " tac.tif ");
    strcat(mbuffer, buffer);
  }

  printf("\n\n\n");
  /* one image */
  out(mbuffer);

  printf("\n\n\n");
  out("gdal_translate -outsize 25%% 25%% -of JPEG tac.tif tac_small.jpg");
  // out("gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir tiles_tac -ps 512 512 -useDirForEachRow tac.tif");

  // printf("\n\n\n");
  // out("mv tiles_tac/0 tiles_tac/1");
  out("[[ -d tmp-stagetac ]] && rmdir tmp-stagetac");

  return 0;
}
