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
#include "chartsfly.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[512];
  char mbuffer[4096];
  char projstr[512];
  snprintf(projstr, sizeof(projstr),"-t_srs '+proj=merc +a=6378137 +b=6378137 +lat_t s=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_def +over' ");
  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/FL; mkdir merge/FL"); // FLY
  out("[[ -d tmp-stagefly ]] && rm -fr tmp-stagefly");
  out("mkdir tmp-stagefly");
  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, dir_ptr, buffer, tmpstr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "tmp-stagefly/tmpstagefly%i", map);

    printf("\n\n# %s\n", maps[map].name);

    // Flyaways come with the tacs
    dir_ptr = "tac";

    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -r cubicspline -co TILED=YES -expand rgb `ls charts/%s/%s*.tif` %s.tif",
	     dir_ptr, n_ptr, tmpstr);
    out(buffer);

    snprintf(buffer, sizeof(buffer),
	     "gdalwarp -co TILED=YES --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -q -r cubicspline %s %s.tif %s_w.tif",
	     projstr, tmpstr, tmpstr);
    out(buffer);
		
    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -r cubicspline -co TILED=YES -q -projwin_srs WGS84 -projwin %f %f %f %f  %s_w.tif merge/%s/%s.tif",
	     maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
	     tmpstr,
	     "FL",
	     n_ptr);
    out(buffer);

    snprintf(buffer, sizeof(buffer), "rm -f %s.tif %s_w.tif", tmpstr, tmpstr);
    out(buffer);

  }

  printf("\n\n\n");

  int gdw=0;
  if (gdw){
    sprintf(mbuffer, "gdalwarp -co TILED=YES --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline %s ", projstr);
  }else{
    sprintf(mbuffer, "gdal_merge.py -o fly.tif ");
  }
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    snprintf(buffer, sizeof(buffer), "merge/FL/%s.tif ", n_ptr);
    strcat(mbuffer, buffer);
  }

  // Use this if using gdalwarp above, otherwise no
  if (gdw){
    snprintf(buffer, sizeof(buffer), " fly.tif ");
    strcat(mbuffer, buffer);
  }

  printf("\n\n\n");
  /* one image */
  out(mbuffer);

  printf("\n\n\n");
  out("gdal_translate -r cubicspline -outsize 25%% 25%% -of JPEG fly.tif fly_small.jpg");
  out("gdal_translate -r cubicspline -outsize 25%% 25%% -of JPEG fly-ak.tif fly-ak_small.jpg");

  // printf("\n\n\n");
  out("[[ -d tmp-stagefly ]] && rmdir tmp-stagefly");

  return 0;
}