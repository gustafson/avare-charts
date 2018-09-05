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
#include <math.h>

typedef struct {
  char name[64];
  int x;
  int y;
  int sizex;
  int sizey;
  char reg[64];
  char sub[64];
} Maps;

int debug=0;
#include "chartsifr.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[512];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs EPSG:3857 ");
  char *n_ptr;
  char *dir_ptr;
  char *order_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/ifr; mkdir -p merge/ifr"); // IFR 48 

  int entries = sizeof(maps) / sizeof(maps[0]);

  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    printf("\n\n# %s\n", maps[map].name);

    if(0 == strcmp(maps[map].reg, "IFAL")) {
      dir_ptr = "ifr";
      order_ptr = "10";
    } else if(0 == strcmp(maps[map].reg, "IF")) {
      dir_ptr = "ifr";
      order_ptr = "11";
    } else if(0 == strcmp(maps[map].reg, "IFPA")) {
      dir_ptr = "ifr";
      order_ptr = "12";
    } else if(0 == strcmp(maps[map].reg, "IFPB")) {
      dir_ptr = "ifr";
      order_ptr = "02";
    } else if(0 == strcmp(maps[map].reg, "GOM")) {
      dir_ptr = "ifr";
      order_ptr = "01";
    } else {
      dir_ptr = "ifr";
      order_ptr = "13";
    }
    
    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "merge/ifr/%s%s%s", order_ptr, maps[map].name, maps[map].sub);

    // This just crops the image
    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -of vrt -r cubic -srcwin %d %d %d %d charts/%s/%s.tif %s_1.vrt",
	     maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	     dir_ptr, n_ptr, tmpstr);
    out(buffer);

    // Create a crop box
    snprintf(buffer, sizeof(buffer),
	     "gdaltindex %s_1.shp %s_1.vrt",
	     tmpstr, tmpstr);
    out(buffer);

    // Increase the number of points in the segment
    snprintf(buffer, sizeof(buffer),
	     "ogr2ogr -segmentize 2500 -t_srs EPSG:4326 %s_2.shp %s_1.shp",
	     tmpstr, tmpstr);
    out(buffer);

    // Project into a lat lon based system
    snprintf(buffer, sizeof(buffer),
	     "ogr2ogr -t_srs EPSG:3857 %s_3.shp %s_2.shp",
	     tmpstr, tmpstr);
    out(buffer);


    double TR;
    if(0 == strcmp(maps[map].name, "ENR_AKL02W")) {
      TR = (20026376.39)/512/(pow(2,9));
    } else {
      TR = (20026376.39)/512/(pow(2,10));
    }

    TR = (20026376.39)/512/(pow(2,5));

    // If the pdf exists, use it.  Elsewise use the tiff
    snprintf(buffer, sizeof(buffer),  
	     "[[ -f charts/%s/%s.pdf ]] && gdalwarp -cutline %s_3.shp -crop_to_cutline -of gtiff -dstnodata 51 -r cubic -tr %g %g %s charts/%s/%s.pdf %s_1.tif",
	     dir_ptr, n_ptr, tmpstr, TR, TR, projstr, dir_ptr, n_ptr, tmpstr);
    out(buffer);
    snprintf(buffer, sizeof(buffer),  
	     "[[ ! -f charts/%s/%s.pdf ]] && gdalwarp -cutline %s_3.shp -crop_to_cutline -of gtiff -dstnodata 51 -r cubic -tr %g %g %s charts/%s/%s.tif %s_1.tif",
	     dir_ptr, n_ptr, tmpstr, TR, TR, projstr, dir_ptr, n_ptr, tmpstr);
    out(buffer);
    
  }

  //  /* one image */
  //  out("\n\n\n# Merge all");
  //  /* Alaska should be first so it is underneath. */
  //  out("gdalbuildvrt -r cubic -resolution highest ifr.vrt -overwrite merge/ifr/1[01]*_2.vrt");
  //  /* out("gdalbuildvrt -r cubic -resolution highest ifr_ak.vrt -overwrite merge/ifr/{0ENR_AKL01_2.vrt,0ENR_AKL02C_2.vrt,0ENR_AKL02W_2.vrt,0ENR_AKL03_2.vrt,0ENR_AKL04north_2.vrt,0ENR_AKL04middle_2.vrt,0ENR_AKL04south_2.vrt}"); */
  //  /* Hawaii done separately */
  //  out("gdalbuildvrt -r cubic -resolution highest ifr_hi.vrt -overwrite merge/ifr/12*_2.vrt");
  //  out("gdalbuildvrt -r cubic -resolution highest ifr_all.vrt -overwrite merge/ifr/*_2.vrt");
  return 0;
}
