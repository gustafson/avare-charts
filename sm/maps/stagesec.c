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
  char filestr[128];
  char cmdstr[4096];

  if (argc==2){debug=1;}

  out("rm -fr merge/AK; mkdir -p merge/AK/QC"); // Alaska sec
  out("rm -fr merge/LF; mkdir -p merge/LF/QC"); // lower 48 sec
  out("rm -fr merge/HI; mkdir -p merge/HI/QC"); // HI sec
  out("rm -fr merge/WC; mkdir -p merge/WC/QC"); // WAC
  out("rm -fr merge/WA; mkdir -p merge/WA/QC"); // WAC Alaska
  out("[[ -d tmp-stagesec ]] && rm -fr tmp-stagesec"); 
  out("mkdir tmp-stagesec"); 

  int entries = sizeof(maps) / sizeof(maps[0]);

  out("[[ -f sec-ak.tif ]] && rm sec-ak.tif");
  out("[[ -f sec-hi.tif ]] && rm sec-hi.tif");
  out("[[ -f sec-48.tif ]] && rm sec-48.tif");
  out("[[ -f wac-48.tif ]] && rm wac-48.tif");
  out("[[ -f sec-ak_small.jpg ]] && rm sec-ak_small.jpg");
  out("[[ -f sec-hi_small.jpg ]] && rm sec-hi_small.jpg");
  out("[[ -f sec-48_small.jpg ]] && rm sec-48_small.jpg");
  out("[[ -f wac-48_small.jpg ]] && rm wac-48_small.jpg");

#pragma omp parallel for private(n_ptr, dir_ptr, failed, count, buffer, filestr, cmdstr) schedule(dynamic,1)
  for(map = 0; map < entries; map++)
    {
      n_ptr = maps[map].name; 
      // Establish a parallel safe tmp name
      snprintf(filestr, sizeof(filestr), "tmp-stagesec/tmpstagesec%i", map);
      // Blank the cmdstr
      snprintf(cmdstr, sizeof(cmdstr), "");
  
      printf("\n\n\n#%s\n", maps[map].name);
 
      if(0 == strcmp(maps[map].reg, "WC") || (0 == strcmp(maps[map].reg, "WA"))) {
	dir_ptr = "wac";
      }
      else {
	dir_ptr = "sec";
      }
 
      if(0 != strcmp(maps[map].reg, "HI")) {
	// Expand to rgb
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -expand rgb `ls charts/%s/%s*.tif|tail -n2|head -n1` %sa.tif;\n",
		 dir_ptr, n_ptr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -expand rgb `ls charts/%s/%s*.tif|tail -n1` %sb.tif;\n",
		 dir_ptr, n_ptr, filestr);
	strcat(cmdstr, buffer);
	// Put a mask near the edges so that no seams show on the tiles
	snprintf(buffer, sizeof(buffer),
		 "nearblack -color 0,0,0 -color 255,255,255 -setmask %sa.tif;\n", filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer),
		 "nearblack -color 0,0,0 -color 255,255,255 -setmask %sb.tif;\n", filestr);
	strcat(cmdstr, buffer);
	// Check to see if the two images are identical
	snprintf(buffer, sizeof(buffer),
		 "[[ `diff %sa.tif %sb.tif` ]] || rm %sb.tif;\n",
		 filestr, filestr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer),
		 "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs WGS84 %s[ab].tif tmp-stagesec/merge%s%s_w.tif;\n",
		 filestr, maps[map].reg, n_ptr);
	strcat(cmdstr, buffer);
      }
      else {
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -expand rgb charts/%s/%s*.tif %s.tif;\n",
		 dir_ptr, n_ptr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer), // This EPSG4326 step is needed for an unknown reason in order to make the lats and longs correct for HI.
		 "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs EPSG:4326 %s.tif tmp-stagesec/merge%s%s_w.tif;\n",
		 filestr, maps[map].reg, n_ptr);
	strcat(cmdstr, buffer);
      }
 		
      if(0 != strcmp(maps[map].reg, "HI")) {
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -projwin %f %f %f %f tmp-stagesec/merge%s%s_w.tif merge/%s/%s_c.tif;\n",
		 maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
		 maps[map].reg, n_ptr, maps[map].reg, n_ptr);
 	strcat(cmdstr, buffer);
      }else{
	snprintf(buffer, sizeof(buffer),
		 "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs WGS84 tmp-stagesec/merge%s%s_w.tif merge/%s/%s_c.tif;\n",
		 maps[map].reg, n_ptr, maps[map].reg, n_ptr);
	strcat(cmdstr, buffer);
      }

      snprintf(buffer, sizeof(buffer), "gdal_translate -outsize 25%% 25%% -of JPEG merge/%s/%s_c.tif merge/%s/QC/%s_c.jpg;\n", maps[map].reg, n_ptr, maps[map].reg, n_ptr);
      strcat(cmdstr, buffer);

      snprintf(buffer, sizeof(buffer), "rm tmp-stagesec/merge%s%s_w.tif;\n", maps[map].reg, n_ptr);
      strcat(cmdstr, buffer);

      snprintf(buffer, sizeof(buffer), "[[ -f %s.tif ]] && rm %s.tif;\n", filestr, filestr); 
      strcat(cmdstr, buffer);
      snprintf(buffer, sizeof(buffer), "[[ -f %sa.tif ]] && rm %sa.tif;\n", filestr, filestr); 
      strcat(cmdstr, buffer);
      snprintf(buffer, sizeof(buffer), "[[ -f %sb.tif ]] && rm %sb.tif;\n", filestr, filestr); 
      strcat(cmdstr, buffer);

      snprintf(buffer, sizeof(buffer), "merge/%s/QC/%s_c.jpg", maps[map].reg, n_ptr);
      failed = 1;
      count = 0;
      while (failed){
	out (cmdstr);
	failed = checkblack (buffer);
	if (count++>3) {
	  failed=0;
	  printf ("# More than three attempts\n");
	  printf ("# Run Manually\n");
	  printf (cmdstr);
	}
      }
    }
  
  printf("\n\n\n");
  /* What follows is stupid parallism */
  snprintf(filestr, sizeof(filestr), "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=4 -multi -r cubicspline -t_srs WGS84");
  // snprintf(filestr, sizeof(filestr), "gdal_merge.py");
#pragma omp parallel num_threads(4) private (buffer)
  {
    map = omp_get_thread_num();
    if (map==0){
      snprintf(buffer, sizeof(buffer), "%s merge/AK/*_c.tif sec-ak.tif", filestr);
    } else if (map==1){
      snprintf(buffer, sizeof(buffer), "%s merge/LF/*_c.tif sec-48.tif", filestr);
    } else if (map==2){
      snprintf(buffer, sizeof(buffer), "%s merge/WC/*_c.tif wac-48.tif", filestr);
    } else if (map==3){
      snprintf(buffer, sizeof(buffer), "%s merge/WA/*_c.tif wac-ak.tif", filestr);
    //   snprintf(buffer, sizeof(buffer), "%s merge/AK/*_c.tif -o sec-ak.tif", filestr);
    // } else if (map==1){
    //   snprintf(buffer, sizeof(buffer), "%s merge/LF/*_c.tif -o sec-48.tif", filestr);
    // } else if (map==2){
    //   snprintf(buffer, sizeof(buffer), "%s merge/WC/*_c.tif -o wac-48.tif", filestr);
    // } else if (map==3){
    //   snprintf(buffer, sizeof(buffer), "%s merge/WA/*_c.tif -o wac-ak.tif", filestr);
    }
    out(buffer);
  }

  printf("\n\n\n");
 
  out("cp merge/HI/*_c.tif sec-hi.tif");
 
#pragma omp parallel num_threads(5)
  {
    map = omp_get_thread_num();
    if (map==0){
      out("gdal_translate -outsize 25% 25% -of JPEG sec-ak.tif sec-ak_small.jpg");
    } else if (map==1){
      out("gdal_translate -outsize 25% 25% -of JPEG sec-48.tif sec-48_small.jpg");
    } else if (map==2){
      out("gdal_translate -outsize 25% 25% -of JPEG wac-48.tif wac-48_small.jpg");
    } else if (map==3){
      out("gdal_translate -outsize 25% 25% -of JPEG wac-ak.tif wac-ak_small.jpg");
    } else if (map==4){
      out("gdal_translate -outsize 25% 25% -of JPEG sec-hi.tif sec-hi_small.jpg");
    }
  }
   
  out("[[ -d tmp-stagesec ]] && rm -fr tmp-stagesec"); 
  return 0;
}

