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
  char buffer[512];
  char tmpstr[128];
  char *n_ptr;
  char *dir_ptr;

  if (argc==2){debug=1;}

  out("rm -fr merge/IFAL; mkdir merge/IFAL;");
  // out("rm -fr tiles_ifal; mkdir tiles_ifal;");

  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, dir_ptr, buffer, tmpstr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "/dev/shm/tmpstageifal%i", map);
    
    printf("\n\n# %s\n\n", maps[map].name);
    
    if(0 == strcmp(maps[map].reg, "IFAL")) {
      dir_ptr = "ifal";
    }
    
    if((0 == strcmp(maps[map].reg, "IFAL"))) {
      
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -outsize 100%% 100%% -srcwin %d %d %d %d charts/%s/%s.tif %s.tif",
	       maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	       dir_ptr,
	       n_ptr,
	       tmpstr);
      out(buffer);

      snprintf(buffer, sizeof(buffer),  
	       //"gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -dstnodata '51 51 51' -r cubicspline -t_srs WGS84 -tr 0.000905038613196 0.000905038613196 %s.tif merge/%s/%s_c.tif",
	       "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -dstnodata '51 51 51' -r cubicspline -t_srs WGS84 -tr 0.000905038613196 0.000905038613196 %s.tif merge/%s/%s_c.tif",
	       tmpstr,
	       maps[map].reg,
	       n_ptr);
      out(buffer);
      
      snprintf(buffer, sizeof(buffer), "nearblack -color 0,0,0 -setmask %s.tif;\n", tmpstr);
      out(buffer);
      
    }
  }
  
  out("rm ifal_east.tif ifal_west.tif");
  
#pragma omp parallel num_threads(2)
  {
    map = omp_get_thread_num();
    if (map==0){
      // out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.000905038613196 0.000905038613196 -te -180 40.225 -119.35 47.25 merge/IFAL/*_c.tif ifal_west.tif");
      out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.000905038613196 0.000905038613196 -te -180 40.225 -119.35 74.25 /dev/shm/tmpstageifal*tif ifal_west.tif");
    } else if (map==1){
      // out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.000905038613196 0.000905038613196 -te 170 44 180 62.25 merge/IFAL/*_c.tif ifal_east.tif");
      out("gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline -t_srs WGS84 -tr 0.000905038613196 0.000905038613196 -te 170 44 180 62.25 /dev/shm/tmpstageifal*tif ifal_east.tif");
    }
  }

  out("rm /dev/shm/tmpstageifal*tif");
  return 0;
}