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
#include "chartsifr.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[128];
  char *n_ptr;
  char *dir_ptr;

  if (argc==2){debug=1;}

  out("rm -fr merge/IF; mkdir merge/IF"); // IFR 48 
  // out("rm -fr tiles_ifr; mkdir tiles_ifr"); // IFR 48 

  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, dir_ptr, buffer, tmpstr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "/dev/shm/tmpstageifr%i", map);

    printf("\n\n# %s\n\n", maps[map].name);

    if(0 == strcmp(maps[map].reg, "IF")) {
      dir_ptr = "iff";
    }

    if((0 == strcmp(maps[map].reg, "IF"))) {
			
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -outsize 100%% 100%% -srcwin %d %d %d %d charts/%s/%s.tif %s.tif",
	       maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	       dir_ptr,
	       n_ptr,
	       tmpstr);
      out(buffer);
			
      snprintf(buffer, sizeof(buffer),  
	       "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -dstnodata '51 51 51' -r cubicspline -t_srs WGS84 %s.tif merge/%s/%s_c.tif",
	       tmpstr,
	       maps[map].reg,
	       n_ptr);
      out(buffer);
    }
    
    snprintf(buffer, sizeof(buffer), "rm -f %s.tif", tmpstr);
    out(buffer);

  }

  /* one image */
  out("rm ifr.tif ifr_small.jpeg");
  out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 merge/IF/*_c.tif ifr_full.tif");
  out("gdal_translate -outsize 50%% 50%% ifr_full.tif ifr.tif");
  out("gdal_translate -outsize 12.5%% 12.5%% -of JPEG ifr.tif ifr_small.jpeg");
  // out("gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir tiles_ifr -ps 512 512 -useDirForEachRow ifr.tif");
  // out("mv tiles_ifr/0 tiles_ifr/3");

  return 0;
}
