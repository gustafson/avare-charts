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

int debug=0;
#include "charts.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char *n_ptr;
  char *dir_ptr;
  int failed;
  int count;

  char buffer[512];
  char filestr[512];
  char cmdstr[4096];
  char projstr[512];
  snprintf(projstr, sizeof(projstr),"-t_srs '+proj=merc +a=6378137 +b=6378137 +lat_t s=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_def +over' ");

    if (argc>=2){debug=1;}

  out("rm -fr merge/AK; mkdir -p merge/AK/QC"); // Alaska sec
  out("rm -fr merge/LF; mkdir -p merge/LF/QC"); // lower 48 sec
  out("rm -fr merge/HI; mkdir -p merge/HI/QC"); // HI sec
  out("rm -fr merge/WC; mkdir -p merge/WC/QC"); // WAC
  out("rm -fr merge/WA; mkdir -p merge/WA/QC"); // WAC Alaska
  out("rm -fr tmp-stagesec; mkdir tmp-stagesec"); 

  int entries = sizeof(maps) / sizeof(maps[0]);

  out("rm -f sec-ak.tif");
  out("rm -f sec-hi.tif");
  out("rm -f sec-48.tif");
  out("rm -f wac-48.tif");
  out("rm -f sec-ak_small.jpg");
  out("rm -f sec-hi_small.jpg");
  out("rm -f sec-48_small.jpg");
  out("rm -f wac-48_small.jpg");

#pragma omp parallel for private(n_ptr, dir_ptr, failed, count, buffer, filestr, cmdstr) schedule(dynamic,1)
  for(map = 0; map < entries; map++)
    {
      n_ptr = maps[map].name; 
      // Establish a parallel safe tmp name
      snprintf(filestr, sizeof(filestr), "merge/%s/%s", maps[map].reg, maps[map].name);
      // Blank the cmdstr
      snprintf(cmdstr, sizeof(cmdstr), "");
  
      printf("\n\n\n#%s\n", maps[map].name);
 
      if(0 == strcmp(maps[map].reg, "WC") || (0 == strcmp(maps[map].reg, "WA"))) {
	dir_ptr = "wac";
      }
      else {
	dir_ptr = "sec";
      }
 
      // if(0 != strcmp(maps[map].reg, "HI")) {
	// Expand to rgb
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -of vrt -co TILED=YES -expand rgb -srcwin %i %i %i %i charts/%s/%s*.tif %s_1.vrt;\n",
		 maps[map].x, maps[map].y, maps[map].dx, maps[map].dy, dir_ptr, n_ptr, filestr);
	strcat(cmdstr, buffer);
	// Put a mask near the edges so that no seams show on the tiles
	snprintf(buffer, sizeof(buffer),
		 // Note the reversed order 2, 1 is appropriate
		 "gdalbuildvrt -addalpha -srcnodata '0 0 0' -srcnodata '255 255 255' %s_2.vrt  %s_1.vrt;\n", filestr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer),
		 "gdalwarp -of vrt -co TILED=YES --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline %s %s_2.vrt %s_3.vrt;\n",
		 projstr, filestr, filestr, filestr);
	strcat(cmdstr, buffer);
      // }
      // else {
      // 	snprintf(buffer, sizeof(buffer),
      // 		 "gdal_translate -of vrt -co TILED=YES -expand rgb -srcwin %i %i %i %i charts/%s/%s*.tif %s_1.vrt;\n",
      // 		 maps[map].x, maps[map].y, maps[map].dx, maps[map].dy, dir_ptr, n_ptr, filestr);
      // 	strcat(cmdstr, buffer);
      // 	snprintf(buffer, sizeof(buffer), // This EPSG4326 step is needed for an unknown reason in order to make the lats and longs correct for HI.
      // 		 // "gdalwarp -co TILED=YES --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs EPSG:4326 %s %s.tif tmp-stagesec/merge%s%s_w.tif;\n",
      // 		 "gdalwarp -of vrt -co TILED=YES --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline %s %s_1.vrt %s_3.vrt;\n",
      // 		 projstr, filestr, filestr);
      // 	strcat(cmdstr, buffer);
      // }
 		
      // if(0 != strcmp(maps[map].reg, "HI")) {
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -of vrt -co TILED=YES -projwin_srs WGS84 -projwin %f %f %f %f %s_3.vrt %s_c.vrt;\n",
		 maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
		 filestr, filestr);
 	strcat(cmdstr, buffer);
      // }else{
      // 	snprintf(buffer, sizeof(buffer),
      // 		 "gdalwarp -of vrt -co TILED=YES --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline %s %s_3.vrt %s_c.vrt;\n",
      // 		 projstr, filestr, filestr);
      // 	strcat(cmdstr, buffer);
      // }

      // snprintf(buffer, sizeof(buffer), "gdal_translate -outsize 25%% 25%% -of JPEG merge/%s/%s_c.vrt merge/%s/QC/%s_c.jpg;\n", maps[map].reg, n_ptr, maps[map].reg, n_ptr);
      // strcat(cmdstr, buffer);

      // snprintf(buffer, sizeof(buffer), "rm -f tmp-stagesec/merge%s%s_w.tif;\n", maps[map].reg, n_ptr);
      // strcat(cmdstr, buffer);

      // snprintf(buffer, sizeof(buffer), "[[ -f %s.tif ]] && rm %s.tif;\n", filestr, filestr); 
      // strcat(cmdstr, buffer);

      // snprintf(buffer, sizeof(buffer), "merge/%s/%s_c.tif", maps[map].reg, n_ptr);
      failed = 1;
      count = 0;
      // while (failed){
      	out (cmdstr);
      	// failed = checkblack (buffer);
      	// if (count++>3) {
      	//   failed=0;
      	//   printf ("# More than three attempts\n");
      	//   printf ("# Run Manually\n");
      	//   printf (cmdstr);
      	// }
	//}
    }
  
  printf("\n\n\n");
  /* What follows is stupid parallism */
  // snprintf(filestr, sizeof(filestr), "gdalwarp -of vrt -co TILED=YES --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=4 -multi -r cubicspline %s", projstr);

  snprintf(filestr, sizeof(filestr), "gdalbuildvrt -resolution highest -overwrite");
  // snprintf(filestr, sizeof(filestr), "gdal_merge.py");
#pragma omp parallel num_threads(2) private (buffer)
  {
    map = omp_get_thread_num();
    if (map==0){
      snprintf(buffer, sizeof(buffer), "%s sec-all.vrt merge/LF/*_c.vrt merge/AK/*_c.vrt merge/HI/*_c.vrt ", filestr);
    } else if (map==1){
      snprintf(buffer, sizeof(buffer), "%s wac-all.vrt merge/WC/*_c.vrt merge/WA/*_c.vrt", filestr);
    }
    out(buffer);
  }

  printf("\n\n\n");
 
  // out("mv merge/HI/*_c.vrt sec-hi.vrt");

// #pragma omp parallel num_threads(5)
//   {
//     map = omp_get_thread_num();
//     if (map==0){
//       out("gdal_translate -outsize 25% 25% -of JPEG sec-ak.vrt sec-ak_small.jpg");
//     } else if (map==1){
//       out("gdal_translate -outsize 25% 25% -of JPEG sec-48.vrt sec-48_small.jpg");
//     } else if (map==2){
//       out("gdal_translate -outsize 25% 25% -of JPEG wac-48.vrt wac-48_small.jpg");
//     } else if (map==3){
//       out("gdal_translate -outsize 25% 25% -of JPEG wac-ak.vrt wac-ak_small.jpg");
//     } else if (map==4){
//       out("gdal_translate -outsize 25% 25% -of JPEG sec-hi.vrt sec-hi_small.jpg");
//     }
//   }
//    
//   out("[[ -d tmp-stagesec ]] && rm -fr tmp-stagesec"); 
  return 0;
}

