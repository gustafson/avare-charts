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
  char filestr[512];
  char mbuffer[4096];
  char projstr[512];
  snprintf(projstr, sizeof(projstr),"-t_srs '+proj=merc +a=6378137 +b=6378137 +lat_t s=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_def +over' ");

  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/TAC");
  out("mkdir -p merge/TAC/run"); // TAC
  out("mkdir -p merge/TAC/T1"); // TAC
  out("mkdir -p merge/TAC/T2"); // TAC
  out("mkdir -p merge/TAC/T3"); // TAC
  out("mkdir -p merge/TAC/T4"); // TAC
  out("mkdir -p merge/TAC/T5"); // TAC
  int entries = sizeof(maps) / sizeof(maps[0]);

#pragma omp parallel for private (n_ptr, dir_ptr, buffer, filestr)
  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    // Establish a parallel safe tmp name
    snprintf(filestr, sizeof(filestr), "merge/TAC/%s/%s", maps[map].reg, maps[map].name);

    printf("\n\n# %s\n", maps[map].name);

    dir_ptr = "tac";
    // snprintf(buffer, sizeof(buffer),
    // 	     "cp `ls charts/%s/%s*.tif|tail -n1` %s",
    // 	     dir_ptr, n_ptr, tmpstr);
    // out(buffer);

    snprintf(buffer, sizeof(buffer),
	     "gdal_translate -of vrt -co TILED=YES -a_nodata '0 0 0' -expand rgb `ls charts/%s/%s*.tif|grep -vi planning | tail -n1` %s_1.vrt",
	     dir_ptr, n_ptr, filestr);
    out(buffer);

    snprintf(buffer, sizeof(buffer), "gdalwarp -of vrt -dstnodata '0 0 0' %s %s_1.vrt %s_2.vrt", projstr, filestr, filestr);
    out(buffer);
		
    if (strcmp(maps[map].reg,"run")!=0){
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -q -projwin_srs WGS84 -projwin %f %f %f %f %s_2.vrt %s_3.vrt",
	       maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
	       filestr, filestr);
      out(buffer);
    } else {
      // Put a mask near the edges so that no seams show on the tiles
      snprintf(buffer, sizeof(buffer),
	       // Note the reversed order 2, 1 is appropriate
	       "gdalbuildvrt -addalpha -srcnodata '0 0 0' -srcnodata '255 255 255' %s_3.vrt  %s_2.vrt;\n", filestr, filestr);
      out(buffer);     
    }
  }

//   int gdw=0;
//   if (gdw){
//     sprintf(mbuffer, "gdalwarp -co TILED=YES --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline %s", projstr);
//   }else{
//     sprintf(mbuffer, "gdal_merge.py -o tac.tif ");
//   }
//   for(map = 0; map < entries; map++) {
//     n_ptr = maps[map].name; 
// 
//     if(0 == strcmp(maps[map].reg, "TS")) {
//       // Don't include the separate TACs (in Alaska and Puerto Rico) in the continental US chart
//       // snprintf(buffer, sizeof(buffer),
//       // 	       "gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir tiles_tac -ps 512 512 -useDirForEachRow merge/TC/%s.tif", n_ptr);
//       // printf("#retiling %s\n", n_ptr);
//       // out(buffer);
//     }
//     else {
//       snprintf(buffer, sizeof(buffer), "merge/TC/%s.tif ", n_ptr);
//       strcat(mbuffer, buffer);
//     }
//   }
// 
//   // Use this if using gdalwarp above, otherwise no
//   if (gdw){
//     snprintf(buffer, sizeof(buffer), " tac.tif ");
//     strcat(mbuffer, buffer);
//   }
// 
//   printf("\n\n\n");
//   /* one image */
//   out(mbuffer);
// 
// 
//   // Do alaska merge
//   if (gdw){
//     sprintf(mbuffer, "gdalwarp -co TILED=YES --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=ALL_CPUS -multi -r cubicspline %s merge/TC/{AnchorageTAC.tif,FairbanksTAC.tif} tac-ak.tif", projstr);
//   }else{
//     sprintf(mbuffer, "gdal_merge.py -o tac-ak.tif merge/TC/{AnchorageTAC.tif,FairbanksTAC.tif}");
//   }
//   out(mbuffer);
  out ("\n\n\n");
  
  out ("pushd merge/TAC/run; gdalbuildvrt -resolution highest tacgroup_1_3.vrt -overwrite ../T1/*_3.vrt; popd");
  out ("pushd merge/TAC/run; gdalbuildvrt -resolution highest tacgroup_2_3.vrt -overwrite ../T2/*_3.vrt; popd");
  out ("pushd merge/TAC/run; gdalbuildvrt -resolution highest tacgroup_3_3.vrt -overwrite ../T3/*_3.vrt; popd");
  out ("pushd merge/TAC/run; gdalbuildvrt -resolution highest tacgroup_4_3.vrt -overwrite ../T4/*_3.vrt; popd");
  out ("pushd merge/TAC/run; gdalbuildvrt -resolution highest tacgroup_5_3.vrt -overwrite ../T5/*_3.vrt; popd");
  return 0;
}
