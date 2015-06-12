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
  char tmpstr[512];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:900913' ");
  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/ifr/ENR_AK*; mkdir -p merge/ifr;");
  int entries = sizeof(maps) / sizeof(maps[0]);

  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "merge/ifr/%s", maps[map].name);
    
    printf("\n\n# %s\n\n", maps[map].name);
    
    if(0 == strcmp(maps[map].reg, "IFAL")) {
      dir_ptr = "ifal";
    }
    
    if((0 == strcmp(maps[map].reg, "IFAL"))) {
      
      snprintf(buffer0, sizeof(buffer0),
	       "gdal_translate -of vrt -srcwin %d %d %d %d charts/%s/%s.tif %s_1.vrt",
	       maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	       dir_ptr,
	       n_ptr,
	       tmpstr);
      out(buffer0);
      
      // START WORKING HERE
      snprintf(buffer0, sizeof(buffer0),  
	       "gdalwarp -of vrt -dstnodata '51 51 51' %s %s_1.vrt %s_2",
	       projstr, tmpstr, tmpstr);
      if (map==4){
	strcat(buffer0, ".vrt -te_srs WGS84 -te -180 63 -133 72");
	out(buffer0);
      }else if(map==5){
	strcpy(buffer1, buffer0);
	strcat(buffer0, "-east.vrt -te_srs WGS84 -te 172.5 48 180 56 ");
	out(buffer0);

	strcat(buffer1, "-west_2.vrt -te_srs WGS84 -te -180 48.5 -133 56.5");
	out(buffer1);
      }else{
	strcat(buffer0, ".vrt");
	out(buffer0);
      }

      // snprintf(buffer0, sizeof(buffer0), "nearblack -color 0,0,0 -setmask %s_2.vrt;\n", tmpstr);
      // out(buffer0);      

    }
  }
  // snprintf(buffer0, sizeof(buffer0), "gdalwarp -of vrt %s -te_srs WGS84 -te -180 45.5 -121.25 72 merge/ifr/*_2.vrt merge/ifr/ifal-west.vrt", projstr);
  // out(buffer0);
  snprintf(buffer0, sizeof(buffer0), "pushd merge/ifr; gdalbuildvrt -resolution highest ifal-west.vrt -overwrite *_2.vrt; popd");
  out(buffer0);
  snprintf(buffer0, sizeof(buffer0), "mv merge/ifr/ENR_AKL02W_2-east.vrt merge/ifr/ifal-east.vrt");
  out(buffer0);

  /* one image */
  out("\n\n\n# Merge all including alaska west and enroute low 48");
  out("gdalbuildvrt -resolution highest ifr.vrt -overwrite merge/ifr/*_2.vrt");
  return 0;
}
