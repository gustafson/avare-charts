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
#include "chartsheli.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[512];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:3857' ");
  char *n_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/hel; mkdir merge/hel"); //
  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, buffer, tmpstr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "merge/hel/%s", maps[map].name);

    printf("\n\n# %s\n", maps[map].name);
    
    if (!strncmp(maps[map].name,"ChicagoOHareInset",15)){
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -expand rgb -srcwin 148 178 3540 3882 `ls charts/hel/%s*.tif|head -n1` %s_1.vrt", n_ptr, tmpstr);
    } else if (!strncmp(maps[map].name,"HoustonNorth",11)){
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -expand rgb -srcwin 1792 77 8556 7186 `ls charts/hel/%s*.tif|head -n1` %s_1.vrt", n_ptr, tmpstr);
    } else if (!strncmp(maps[map].name,"HoustonSouth",11)){
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -expand rgb -srcwin 1789 77 8552 7420 `ls charts/hel/%s*.tif|head -n1` %s_1.vrt", n_ptr, tmpstr);
    } else if (!strncmp(maps[map].name,"BostonDowntown",15)){
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -expand rgb -srcwin 1550 295 7400 8240 `ls charts/hel/%s*.tif|head -n1` %s_1.vrt", n_ptr, tmpstr);
    } else if (!strncmp(maps[map].name,"Boston",6)){ // BostonDowntown comes before BostonHEL
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -expand rgb `ls charts/hel/%s*.tif|tail -n1` %s_1.vrt", n_ptr, tmpstr);
    } else if (!strncmp(maps[map].name,"DowntownManhattan",15)){
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -expand rgb -srcwin 1660 232 4188 3958 `ls charts/hel/%s*.tif|head -n1` %s_1.vrt", n_ptr, tmpstr);
    } else{
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r cubicspline -a_nodata '0 0 0' -expand rgb `ls charts/hel/%s*.tif|head -n1` %s_1.vrt", n_ptr, tmpstr);
    }
    out(buffer);

    snprintf(buffer, sizeof(buffer),
	     "gdalwarp -of gtiff -r cubicspline -dstnodata '0 0 0' %s %s_1.vrt %s_2.tif",
	     projstr, tmpstr, tmpstr);
    out(buffer);
		
//    if (!strncmp(maps[map].name,"ChicagoOHareInset",15) ||
//	!strncmp(maps[map].name,"Houston",6) ||
//	!strncmp(maps[map].name,"BostonDowntown",15) ||
//	!strncmp(maps[map].name,"DowntownManhattan",15)){
//      snprintf(buffer, sizeof(buffer), "mv %s_2.vrt %s_3.vrt", tmpstr, tmpstr);
//	       
//    } else {
//      snprintf(buffer, sizeof(buffer),
//	       "gdal_translate -of vrt -r cubicspline -q -projwin_srs WGS84 -projwin %f %f %f %f  %s_2.vrt %s_3.vrt",
//	       maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd, tmpstr, tmpstr);
//    }      
//    out(buffer);
  }


//   snprintf(buffer, sizeof(buffer),
//   	   "rename _3 _4 `ls merge/hel/*_3.vrt|grep -vi \"Baltimore\\|Boston\\|Chicago\\|York\\|LosAngeles\\|DowntownManhattan\\|EasternLongIsland\\|Houston\\|USGulf\\|Washington\\|inset\\|downtown\"`");
//   out(buffer);



  // We'll have to deal with the special areas of New York and Boston later
  out("\n\n\n");
//   snprintf(buffer, sizeof(buffer),
//   	   "gdalbuildvrt -r near -resolution highest -srcnodata \"250\" merge/hel/BaltimoreWashington_4.vrt -overwrite merge/hel/Baltimore_3.vrt merge/hel/Washington_3.vrt");
//   out(buffer);
// 
//   snprintf(buffer, sizeof(buffer),
//   	   "gdalbuildvrt -r near -resolution highest -srcnodata \"250\" merge/hel/Boston_4.vrt -overwrite merge/hel/Boston_3.vrt merge/hel/BostonDowntown_3.vrt");
//   out(buffer);
// 
//   snprintf(buffer, sizeof(buffer),
//   	   "gdalbuildvrt -r near -resolution highest -srcnodata \"250\" merge/hel/Chicago_4.vrt -overwrite merge/hel/Chicago_3.vrt merge/hel/ChicagoOHareInset_3.vrt");
//   out(buffer);
// 
//   // snprintf(buffer, sizeof(buffer),
//   // 	   "gdalbuildvrt -r near -resolution highest merge/hel/Houston_4.vrt -overwrite merge/hel/USGulfCoast*3.vrt merge/hel/Houston*3.vrt");
//   // out(buffer);
// 

  out("## Combine the ones that are close to each other that create overlaps in tile structure");
  out("##   _3.vrt are just for eventual zip");
  out("##   _4.vrt are just for overview");
  snprintf(buffer, sizeof(buffer),
	   "gdalbuildvrt -r near -resolution highest merge/hel/Houston_3.vrt -overwrite merge/hel/Houston*2.tif");
  out(buffer);

  snprintf(buffer, sizeof(buffer),
	   "gdalbuildvrt -r near -resolution highest merge/hel/USGulfHouston_4.vrt -overwrite merge/hel/USGulfCoast_2.tif merge/hel/Houston_3.vrt");
  out(buffer);

  snprintf(buffer, sizeof(buffer),
	   "gdalbuildvrt -r near -resolution highest merge/hel/BaltimoreWashington_4.vrt -overwrite merge/hel/Baltimore_2.tif merge/hel/Washington_2.tif");
  out(buffer);

  snprintf(buffer, sizeof(buffer),
   	   "gdalbuildvrt -r near -resolution highest -srcnodata \"250\" merge/hel/LosAngeles_3.vrt -overwrite merge/hel/LosAngeles*_2.tif");
  out(buffer);
 
//  snprintf(buffer, sizeof(buffer),
//   	   "gdalbuildvrt -r near -resolution highest -srcnodata \"250\" merge/hel/NewYork_4.vrt -overwrite merge/hel/EasternLongIsland*3.vrt merge/hel/NewYork_3.vrt merge/hel/DowntownManhattan*3.vrt ");
//  out(buffer);

  snprintf(buffer, sizeof(buffer),
     	   "gdalbuildvrt -r near -resolution highest -srcnodata \"250\" merge/hel/NewYork_3.vrt -overwrite merge/hel/EasternLongIsland*2.tif merge/hel/NewYork_2.tif");
  out(buffer);

  // File order happens to work out on these
  snprintf(buffer, sizeof(buffer),
   	   "gdalbuildvrt -r near -resolution highest -srcnodata \"250\" heli.vrt -overwrite merge/hel/*2.tif");
  out(buffer);
  

  return 0;
}
