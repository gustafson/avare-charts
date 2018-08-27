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
#include "chartsifh.c"
#include "stageall.c"

int main(int argc, char *argv[])
{
  int map;
  char buffer[512];
  char tmpstr[512];
  char projstr[512];
  snprintf(projstr, sizeof(projstr), "-t_srs 'EPSG:900913' ");
  char *n_ptr;
  char *dir_ptr;

  if (argc>=2){debug=1;}

  out("rm -fr merge/ifh; mkdir -p merge/ifh");

  int entries = sizeof(maps) / sizeof(maps[0]);

  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name; 

    printf("\n\n# %s\n\n", maps[map].name);

    if(0 == strcmp(maps[map].reg, "IFH")) {
      dir_ptr = "ifr";
    }else if(0 == strcmp(maps[map].reg, "IFAH")) {
      dir_ptr = "ifr";
    }else if(0 == strcmp(maps[map].reg, "IFAL")) {
      dir_ptr = "ifr";
    }else{
      dir_ptr = "ifr";
    }

    // Establish a parallel safe tmp name
    snprintf(tmpstr, sizeof(tmpstr), "merge/ifh/%02i%s", map, maps[map].name);
    
    if((0 == strcmp(maps[map].reg, "IFH")) ||
       (0 == strcmp(maps[map].reg, "IFAL")) ||
       (0 == strcmp(maps[map].reg, "IFAH"))) {
			
      snprintf(buffer, sizeof(buffer),
	       "gdal_translate -of vrt -r lanczos -srcwin %d %d %d %d charts/%s/%s.tif %s_1.vrt",
	       maps[map].x, maps[map].y, maps[map].sizex, maps[map].sizey,
	       dir_ptr, n_ptr, tmpstr);
      out(buffer);
      
      snprintf(buffer, sizeof(buffer),  
      	       "gdalwarp -of vrt -r near -dstnodata '51 51 51' %s %s_1.vrt %s_2.vrt\n", // -tap -tr 102.5 102.5 
      	       projstr, tmpstr, tmpstr);
      out(buffer);
    }
  }

// 00ENR_P01_1.vrt
// Upper Left  (-9430341.229, 2778369.121) (122d52'52.85"E, 15d15'15.99"N)
// Lower Left  (-9430516.428, -574709.615) (141d39'24.25"E,  9d 4'23.33"S)
// Upper Right (-7244952.694, 2778374.952) (141d 0'59.81"E, 28d23'38.17"N)
// Lower Right (-7245127.893, -574703.784) (158d 3'35.47"E,  0d40'46.46"N)
// 01ENR_P01_1.vrt
// Upper Left  (-7244211.884, 2778374.954) (141d 1'24.18"E, 28d23'52.80"N)
// Lower Left  (-7244501.509,-2764650.919) (166d 8' 3.26"E, 16d 0'15.20"S)
// Upper Right ( 2120363.192, 2778399.941) (106d 3' 1.36"W, 47d24'53.31"N)
// Lower Right ( 2120073.568,-2764625.933) (115d28'32.25"W,  4d22'27.94"S)
// 04ENR_AKH02_1.vrt
// Upper Left  (-3327345.931, 1268588.448) (152d33'49.75"E, 50d55'48.83"N)
// Lower Left  (-3205095.050, -109456.766) (164d55'22.72"E, 41d26'29.71"N)
// Upper Right (  286536.323, 1589322.505) (147d49'41.84"W, 65d27' 9.96"N)
// Lower Right (  408787.204,  211277.290) (147d44'46.08"W, 52d47'41.89"N)

  /* one image */
  out("\n\n\n# Merge all");
  // The pacific should be first, so it is underneath
  out("gdalbuildvrt -r near -srcnodata '51 51 51' -vrtnodata '51 51 51' -resolution highest ifh.vrt -overwrite merge/ifh/*_2.vrt\n"); // 
  out("gdal_translate -r near -projwin_srs WGS84 -projwin  123.5 62.0 180.0 -5.25 -a_nodata '51 51 51' -of vrt ifh.vrt ifh-east.vrt"); // 
  out("gdal_translate -r near -projwin_srs WGS84 -projwin -180.0 72.2 -62.7 -5.25 -a_nodata '51 51 51' -of vrt ifh.vrt ifh-west.vrt"); // 

  return 0;
}
