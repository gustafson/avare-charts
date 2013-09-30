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
  out("rm -fr `ls /dev/shm/*|grep -v pulse`");

  int entries = sizeof(maps) / sizeof(maps[0]);

  /* one image */
  out("rm -fr sec-ak.tif sec-hi.tif sec-48.tif wac-48.tif wac-ak.tif sec-ak_small.tif sec-48_small.tif wac-48_small.tif wac-ak_small.tif tiles_sec/*");

#pragma omp parallel for private(n_ptr, dir_ptr, failed, count, buffer, filestr, cmdstr) schedule(dynamic,1)
  for(map = 0; map < entries; map++)
    {
      n_ptr = maps[map].name; 
      // Establish a parallel safe tmp name
      snprintf(filestr, sizeof(filestr), "/dev/shm/tmpstage%i", map);
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
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -expand rgb `ls charts/%s/%s*.tif|tail -n2|head -n1` %sa.tif;\n",
		 dir_ptr, n_ptr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -expand rgb `ls charts/%s/%s*.tif|tail -n1` %sb.tif;\n",
		 dir_ptr, n_ptr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer),
		 "[[ `diff %sa.tif %sb.tif` ]] || rm %sb.tif;\n",
		 filestr, filestr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer),
		 "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs WGS84 %s[ab].tif /dev/shm/merge%s%s_w.tif;\n",
		 filestr, maps[map].reg, n_ptr);
	strcat(cmdstr, buffer);
      }
      else {
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -expand rgb charts/%s/%s*.tif %s.tif;\n",
		 dir_ptr, n_ptr, filestr);
	strcat(cmdstr, buffer);
	snprintf(buffer, sizeof(buffer), // This EPSG4326 step is needed for an unknown reason in order to make the lats and longs correct for HI.
		 "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs EPSG:4326 %s.tif /dev/shm/merge%s%s_w.tif;\n",
		 filestr, maps[map].reg, n_ptr);
	strcat(cmdstr, buffer);
      }
 		
      if(0 != strcmp(maps[map].reg, "HI")) {
	snprintf(buffer, sizeof(buffer),
		 "gdal_translate -projwin %f %f %f %f /dev/shm/merge%s%s_w.tif merge/%s/%s_c.tif;\n",
		 maps[map].lonl, maps[map].latu, maps[map].lonr, maps[map].latd,
		 maps[map].reg, n_ptr, maps[map].reg, n_ptr);
	strcat(cmdstr, buffer);
      }else{
	snprintf(buffer, sizeof(buffer),
		 "gdalwarp --config GDAL_CACHEMAX 4096 -wm 2048 -wo NUM_THREADS=2 -multi -r cubicspline -t_srs WGS84 /dev/shm/merge%s%s_w.tif merge/%s/%s_c.tif;\n",
		 maps[map].reg, n_ptr, maps[map].reg, n_ptr);
	strcat(cmdstr, buffer);
      }

      snprintf(buffer, sizeof(buffer), "gdal_translate -outsize 25%% 25%% -of JPEG merge/%s/%s_c.tif merge/%s/QC/%s_c.jpg;\n", maps[map].reg, n_ptr, maps[map].reg, n_ptr);
      strcat(cmdstr, buffer);

      snprintf(buffer, sizeof(buffer), "rm /dev/shm/merge%s%s_w.tif;\n", maps[map].reg, n_ptr);
      strcat(cmdstr, buffer);

      snprintf(buffer, sizeof(buffer), "rm %s[ab].tif;\n", filestr); 
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
  snprintf(filestr, sizeof(filestr), "gdalwarp --config GDAL_CACHEMAX 16384 -wm 2048 -wo NUM_THREADS=4 -multi -r cubicspline -t_srs WGS84");
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
    }
    out(buffer);
  }
   
  printf("\n\n\n");
 
  out("cp merge/HI/*_c.tif sec-hi.tif");
 
#pragma omp parallel num_threads(5)
  {
    map = omp_get_thread_num();
    if (map==0){
      out("gdal_translate -outsize 25% 25% -of JPEG sec-ak.tif sec-ak_small.jpeg");
    } else if (map==1){
      out("gdal_translate -outsize 25% 25% -of JPEG sec-48.tif sec-48_small.jpeg");
    } else if (map==2){
      out("gdal_translate -outsize 25% 25% -of JPEG wac-48.tif wac-48_small.jpeg");
    } else if (map==3){
      out("gdal_translate -outsize 25% 25% -of JPEG wac-ak.tif wac-ak_small.jpeg");
    } else if (map==4){
      out("gdal_translate -outsize 25% 25% -of JPEG sec-hi.tif sec-hi_small.jpeg");
    }
  }
   


//   printf("\n\n\n");
//   out("mkdir tiles_sec");
//   out("mkdir /dev/shm/tiles_sec_a");
//   out("mkdir /dev/shm/tiles_sec_b");
// 
// #pragma omp parallel num_threads(5)
//   {
//     map = omp_get_thread_num();
//     if (map==0){
//       out("gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir /dev/shm/tiles_sec_a -ps 512 512 -useDirForEachRow wac-48.tif");
//     } else if (map==1){
//       out("gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir /dev/shm/tiles_sec_a -ps 512 512 -useDirForEachRow wac-ak.tif");
//     } else if (map==2){
//       out("gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir /dev/shm/tiles_sec_b -ps 512 512 -useDirForEachRow sec-hi.tif");
//     } else if (map==3){
//       out("gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir /dev/shm/tiles_sec_b -ps 512 512 -useDirForEachRow sec-ak.tif");
//     } else if (map==4){
//       out("gdal_retile.py -r cubicspline -co COMPRESS=DEFLATE -co ZLEVEL=6 -levels 4 -targetDir /dev/shm/tiles_sec_b -ps 512 512 -useDirForEachRow sec-48.tif");
//     }
//   }
//   
//   printf("\n\n\n");
//   out("mv /dev/shm/tiles_sec_a/0 tiles_sec/2");
//   out("mv /dev/shm/tiles_sec_b/0 tiles_sec/0");
  out("rm -fr `ls /dev/shm/*|grep -v pulse`");
  return 0;
}

