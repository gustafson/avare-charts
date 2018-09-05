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
  char tmpstr0[512];
  char tmpstr1[512];
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
    snprintf(tmpstr0, sizeof(tmpstr0), "%s%s%s", order_ptr, maps[map].name, maps[map].sub);
    snprintf(tmpstr1, sizeof(tmpstr1), "merge/ifr/%s", tmpstr0);

    // This just crops the image
    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -of vrt -r cubic -srcwin %d %d %d %d charts/%s/%s.tif %s_1.vrt",
	     maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	     dir_ptr, n_ptr, tmpstr1);
    out(buffer);

    // Remove old files
    out("rm -f step_?.shp");
    out("rm -f step_?[ew].shp");
    
    // Create a crop box
    snprintf(buffer, sizeof(buffer),
	     "gdaltindex step_1.shp %s_1.vrt",
	     tmpstr1);
    out(buffer);
    
    // Increase the number of points in the segment
    out("ogr2ogr -segmentize 500 -t_srs EPSG:4326 step_2.shp step_1.shp");
    
    // Shift its lon and that of the western hemisphere (now going from 0 to 360)                                                                                                                                                                                          
    out("ogr2ogr step_3.shp step_2.shp -dialect sqlite -sql \"select ST_Shift_Longitude(Geometry) from step_2\";");
    out("ogr2ogr shiftedwest.shp west.shp -dialect sqlite -sql \"select ST_Shift_Longitude(Geometry) from west\";");

    // Now clip the shape file to hemispheres
    out("ogr2ogr -clipsrc shiftedwest.shp step_3w.shp step_3.shp;");
    out("ogr2ogr -clipsrc east.shp step_3e.shp step_3.shp;");

    // If two are the same, delete the other one
    out("[[ -f step_3w.shp ]] && diff step_3.shp step_3w.shp > /dev/null && rm step_3e.shp");
    out("[[ -f step_3e.shp ]] && diff step_3.shp step_3e.shp > /dev/null && rm step_3w.shp");
    
    // Project into a lat lon based system
    out("[[ -f step_3w.shp ]] && ogr2ogr -t_srs EPSG:3857 step_4w.shp step_3w.shp");
    out("[[ -f step_3e.shp ]] && ogr2ogr -t_srs EPSG:3857 step_4e.shp step_3e.shp");

    // Create a geojson instead
    snprintf(buffer, sizeof(buffer),
	     "[[ -f step_4w.shp ]] && ogr2ogr %s_westernhemisphere.geojson step_4w.shp",
	     tmpstr1);
    out(buffer);
    snprintf(buffer, sizeof(buffer),
	     "[[ -f step_4e.shp ]] && ogr2ogr %s_easternhemisphere.geojson step_4e.shp",
	     tmpstr1);
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
	     "[[ -f charts/%s/%s.pdf && -f %s_westernhemisphere.geojson ]] && gdalwarp -overwrite -cutline %s_westernhemisphere.geojson -crop_to_cutline -of gtiff -dstnodata 51 -r cubic -tr %g %g %s charts/%s/%s.pdf %s_westernhemisphere.tif",
	     dir_ptr, n_ptr, tmpstr1, tmpstr1, TR, TR, projstr, dir_ptr, n_ptr, tmpstr1);
    out(buffer);
    snprintf(buffer, sizeof(buffer),  
	     "[[ -f charts/%s/%s.pdf && -f %s_easternhemisphere.geojson ]] && gdalwarp -overwrite -cutline %s_easternhemisphere.geojson -crop_to_cutline -of gtiff -dstnodata 51 -r cubic -tr %g %g %s charts/%s/%s.pdf %s_easternhemisphere.tif",
	     dir_ptr, n_ptr, tmpstr1, tmpstr1, TR, TR, projstr, dir_ptr, n_ptr, tmpstr1);
    out(buffer);
    snprintf(buffer, sizeof(buffer),  
	     "[[ -f charts/%s/%s.tif && -f %s_westernhemisphere.geojson ]] && gdalwarp -overwrite -cutline %s_westernhemisphere.geojson -crop_to_cutline -of gtiff -dstnodata 51 -r cubic -tr %g %g %s charts/%s/%s.tif %s_westernhemisphere.tif",
	     dir_ptr, n_ptr, tmpstr1, tmpstr1, TR, TR, projstr, dir_ptr, n_ptr, tmpstr1);
    out(buffer);
    snprintf(buffer, sizeof(buffer),  
	     "[[ -f charts/%s/%s.tif && -f %s_easternhemisphere.geojson ]] && gdalwarp -overwrite -cutline %s_easternhemisphere.geojson -crop_to_cutline -of gtiff -dstnodata 51 -r cubic -tr %g %g %s charts/%s/%s.tif %s_easternhemisphere.tif",
	     dir_ptr, n_ptr, tmpstr1, tmpstr1, TR, TR, projstr, dir_ptr, n_ptr, tmpstr1);
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
