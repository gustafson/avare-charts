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
#include "chartsifal.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer0[512];
  char buffer1[512];
  char tmpstr[128];
  char *n_ptr;
  char *dir_ptr;

  if (argc==2){debug=1;}

  out("rm -fr merge/IFAL; mkdir merge/IFAL;");
  out("[[ -d tmp-stageifal ]] && rm -fr tmp-stageifal");
  out("mkdir tmp-stageifal");

  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, dir_ptr, buffer0, tmpstr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "tmp-stageifal/tmpstageifal%i", map);
    
    printf("\n\n# %s\n\n", maps[map].name);
    
    if(0 == strcmp(maps[map].reg, "IFAL")) {
      dir_ptr = "ifal";
    }
    
    if((0 == strcmp(maps[map].reg, "IFAL"))) {
      
      snprintf(buffer0, sizeof(buffer0),
	       "gdal_translate -outsize 100%% 100%% -srcwin %d %d %d %d charts/%s/%s.tif %s.tif",
	       maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	       dir_ptr,
	       n_ptr,
	       tmpstr);
      out(buffer0);

      snprintf(buffer0, sizeof(buffer0),  
	       "[[ -f merge/%s/%s_c.tif ]] && rm merge/%s/%s_c.tif",
	       maps[map].reg, n_ptr, maps[map].reg, n_ptr);
      out(buffer0);

      snprintf(buffer0, sizeof(buffer0),  
	       "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs WGS84 -tr 0.001253199658703 0.001253199658703 %s.tif merge/%s/%s_c",
	       tmpstr,
	       maps[map].reg,
	       n_ptr);
      if (map==4){
	strcat(buffer0, ".tif -te -180 63 -133 72");
	out(buffer0);
      }else if(map==5){
	strcpy(buffer1, buffer0);
	strcat(buffer0, "-east.tif -te 172.5 48 180 56 ");
	out(buffer0);

	snprintf(buffer0, sizeof(buffer0), "mv merge/%s/%s_c-east.tif ifal-east.tif", maps[map].reg, n_ptr);
	out(buffer0);      

	strcat(buffer1, ".tif -te -180 48.5 -133 56.5");
	out(buffer1);
      }else{
	strcat(buffer0, ".tif");
	out(buffer0);
      }

      snprintf(buffer0, sizeof(buffer0), "nearblack -color 0,0,0 -setmask merge/%s/%s_c.tif;\n", maps[map].reg, n_ptr);
      out(buffer0);      

    }
  }
  
  out("rm ifal-west.tif");
  
#pragma omp parallel num_threads(2)
  {
    map = omp_get_thread_num();
    if (map==0){
      out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.001253199658703 0.001253199658703 -te -180 45.5 -121.25 72 merge/IFAL/*_c.tif ifal-west.tif");
      out("gdal_translate -outsize 10% 10% -of JPEG ifal-west.tif ifal-west_small.jpg");
    } else if (map==1){
      // out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.001253199658703 0.001253199658703 -te 172.5 48 180 56 merge/IFAL/*_c.tif ifal-east.tif");
      out("gdal_translate -outsize 10% 10% -of JPEG ifal-east.tif ifal-east_small.jpg");
    }
  }

  out("rm tmp-stageifal/tmpstageifal*tif");
  out("[[ -d tmp-stageifal ]] && rmdir tmp-stageifal");
  return 0;
}
