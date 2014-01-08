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
#include "chartsifah.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[128];
  char *n_ptr;
  char *dir_ptr;

  if (argc==2){debug=1;}

  out("rm -fr merge/IFAH; mkdir merge/IFAH;");
  out("[[ -d tmp-stageifah ]] && rm -fr tmp-stageifah"); 
  out("mkdir tmp-stageifah"); 

  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, dir_ptr, buffer, tmpstr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "tmp-stageifah/tmpstageifah%i", map);
    
    printf("\n\n# %s\n\n", maps[map].name);
    
    if(0 == strcmp(maps[map].reg, "IFAH")) {
      dir_ptr = "ifah";
    }
    
    if((0 == strcmp(maps[map].reg, "IFAH"))) {
      
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -outsize 100%% 100%% -srcwin %d %d %d %d charts/%s/%s.tif %s.tif",
	       maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	       dir_ptr,
	       n_ptr,
	       tmpstr);
      out(buffer);

      snprintf(buffer, sizeof(buffer),  
	       "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs WGS84 -tr 0.002 0.002 %s.tif merge/%s/%s_%i_c.tif",
	       tmpstr,
	       maps[map].reg,
	       n_ptr, map);
      if (map==2){
	strcat(buffer, " -te -180 43 -119.35 74.25");
      }
      out(buffer);
      
    snprintf(buffer, sizeof(buffer), "nearblack -color 0,0,0 -setmask merge/%s/%s_%i_c.tif;", maps[map].reg, n_ptr, map);
      out(buffer);
      
    }
  }
  
  out("rm ifah_east.tif ifah_west.tif");
  
#pragma omp parallel num_threads(2)
  {
    map = omp_get_thread_num();
    if (map==0){
      out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.002 0.002 -te -180 43 -119.35 74.25 merge/IFAH/*_c.tif ifah_west.tif");
      out("gdal_translate -outsize 10% 10% -of JPEG ifah_west.tif ifah_west_small.jpg");
    } else if (map==1){
      out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.002 0.002 -te 152.5 41.25 180 62.25 tmp-stageifah/tmpstageifah2.tif ifah_east.tif");
      out("gdal_translate -outsize 10% 10% -of JPEG ifah_east.tif ifah_east_small.jpg");
    }
  }

  out("rm tmp-stageifah/tmpstageifah*tif");
  out("[[ -d tmp-stageifah ]] && rmdir tmp-stageifah"); 

  return 0;
}
