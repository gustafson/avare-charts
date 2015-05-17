/*
  Copyright (c) 2014, Peter A. Gustafson
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright
  * notice, this list of conditions and the following disclaimer.  *
  * Redistributions in binary form must reproduce the above
  * copyright notice, this list of conditions and the following
  * disclaimer in the documentation and/or other materials provided
  * with the distribution.
  *
  *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
  *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
  *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
  *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  *     SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <wand/magick_wand.h>


int tacareas(float lon, float lat){
  // for a in tmp-stagetac/tmpstagetac*w.tif; do echo $a; ./retile_corners.sh $a;done |
  // awk '{printf ("%3.7f %3.7f %3.7f %3.7f\n", $2, $4, $1, $3)}'done |column -t -s" " |sort -n > tmp.txt
  if (((lat <= 18.8032889) && (lat >= 17.6085164) && (lon >= -67.8146734 ) && (lon <= -64.2183681 )) ||
      ((lat <= 26.7801453) && (lat >= 25.0872603) && (lon >= -81.5117433 ) && (lon <= -79.3023073 )) ||
      ((lat <= 28.6883974) && (lat >= 27.2208408) && (lon >= -83.4251477 ) && (lon <= -81.4968395 )) ||
      ((lat <= 29.2735015) && (lat >= 27.7846787) && (lon >= -82.6798529 ) && (lon <= -80.1234786 )) ||
      ((lat <= 30.6038363) && (lat >= 29.0550929) && (lon >= -96.4837119 ) && (lon <= -94.4924410 )) ||
      ((lat <= 30.6835962) && (lat >= 29.5181945) && (lon >= -91.6256171 ) && (lon <= -89.1852261 )) ||
      ((lat <= 33.6478365) && (lat >= 32.4533341) && (lon >= -119.0371835) && (lon <= -116.2725877)) ||
      ((lat <= 33.6968546) && (lat >= 32.0189278) && (lon >= -98.5919589 ) && (lon <= -95.8468456 )) ||
      ((lat <= 34.1989348) && (lat >= 32.7461128) && (lon >= -113.5741782) && (lon <= -111.1539615)) ||
      ((lat <= 34.4180496) && (lat >= 32.9503878) && (lon >= -85.6632367 ) && (lon <= -83.5784898 )) ||
      ((lat <= 34.5427343) && (lat >= 33.3659066) && (lon >= -120.2304523) && (lon <= -116.4165754)) ||
      ((lat <= 35.8169704) && (lat >= 34.3545366) && (lon >= -91.2592057 ) && (lon <= -88.6419055 )) ||
      ((lat <= 36.0004411) && (lat >= 34.5506998) && (lon >= -82.1970179 ) && (lon <= -80.0712664 )) ||
      ((lat <= 36.8490599) && (lat >= 35.6445736) && (lon >= -116.3606183) && (lon <= -113.8414903)) ||
      ((lat <= 38.2610791) && (lat >= 36.8566008) && (lon >= -123.9102324) && (lon <= -121.3587748)) ||
      ((lat <= 39.2817932) && (lat >= 37.6187844) && (lon >= -106.3030383) && (lon <= -103.4146905)) ||
      ((lat <= 39.3181984) && (lat >= 38.1405780) && (lon >= -91.4742150 ) && (lon <= -89.2291489 )) ||
      ((lat <= 39.8383397) && (lat >= 38.1337403) && (lon >= -78.7436606 ) && (lon <= -75.7410802 )) ||
      ((lat <= 40.1337256) && (lat >= 38.4426025) && (lon >= -85.9288192 ) && (lon <= -83.6770159 )) ||
      ((lat <= 40.1376993) && (lat >= 38.6601145) && (lon >= -96.3014706 ) && (lon <= -93.5413450 )) ||
      ((lat <= 40.6250524) && (lat >= 38.9822726) && (lon >= -76.4245233 ) && (lon <= -73.8588844 )) ||
      ((lat <= 40.6318773) && (lat >= 38.9581134) && (lon >= -105.9745444) && (lon <= -103.7046637)) ||
      ((lat <= 41.1076215) && (lat >= 39.9246428) && (lon >= -81.3774296 ) && (lon <= -78.9583204 )) ||
      ((lat <= 41.3752535) && (lat >= 40.1718182) && (lon >= -75.6819030 ) && (lon <= -72.6247153 )) ||
      ((lat <= 41.5539102) && (lat >= 40.0853007) && (lon >= -113.3159577) && (lon <= -110.6424547)) ||
      ((lat <= 42.0118915) && (lat >= 40.8099217) && (lon >= -83.0313589 ) && (lon <= -80.5666563 )) ||
      ((lat <= 42.5926996) && (lat >= 41.4259328) && (lon >= -89.1773967 ) && (lon <= -86.8441013 )) ||
      ((lat <= 42.7818474) && (lat >= 41.4211574) && (lon >= -84.9954038 ) && (lon <= -82.6536476 )) ||
      ((lat <= 42.9352379) && (lat >= 41.2023362) && (lon >= -72.2954816 ) && (lon <= -69.0496879 )) ||
      ((lat <= 45.4900710) && (lat >= 44.3054192) && (lon >= -94.4704670 ) && (lon <= -91.5772986 )) ||
      ((lat <= 48.1669104) && (lat >= 46.7006461) && (lon >= -123.6710027) && (lon <= -121.0710339)) ||
      ((lat <= 61.6915861) && (lat >= 60.5106253) && (lon >= -153.1149120) && (lon <= -147.6964292)) ||
      ((lat <= 65.2713107) && (lat >= 64.0827414) && (lon >= -150.7729149) && (lon <= -145.6720389))){
    return 1;
  }else{
    return 0;
  }
  
  // if (
  //     ((lat <= 61.650000) && (lat >= 60.566670) && (lon >= -152.00000) && (lon <= -148.00000)) ||
  //     ((lat <= 34.400000) && (lat >= 33.000000) && (lon >= -85.500000) && (lon <= -83.600000)) ||
  //     ((lat <= 39.800000) && (lat >= 38.166700) && (lon >= -78.600000) && (lon <= -75.770000)) ||
  //     ((lat <= 42.900000) && (lat >= 41.250000) && (lon >= -72.300000) && (lon <= -69.500000)) ||
  //     ((lat <= 35.900000) && (lat >= 34.580000) && (lon >= -82.100000) && (lon <= -80.080000)) ||
  //     ((lat <= 42.500000) && (lat >= 41.430000) && (lon >= -89.100000) && (lon <= -86.900000)) ||
  //     ((lat <= 40.100000) && (lat >= 38.460000) && (lon >= -85.900000) && (lon <= -83.700000)) ||
  //     ((lat <= 41.950000) && (lat >= 40.840000) && (lon >= -82.900000) && (lon <= -80.600000)) ||
  //     ((lat <= 39.250000) && (lat >= 37.650000) && (lon >= -106.20000) && (lon <= -103.45000)) ||
  //     ((lat <= 33.670000) && (lat >= 32.050000) && (lon >= -98.500000) && (lon <= -95.850000)) ||
  //     ((lat <= 40.600000) && (lat >= 39.250000) && (lon >= -105.90000) && (lon <= -103.73000)) ||
  //     ((lat <= 42.750000) && (lat >= 41.420000) && (lon >= -84.800000) && (lon <= -82.660000)) ||
  //     ((lat <= 65.250000) && (lat >= 64.150000) && (lon >= -150.60000) && (lon <= -145.80000)) ||
  //     ((lat <= 30.550000) && (lat >= 29.100000) && (lon >= -96.400000) && (lon <= -94.500000)) ||
  //     ((lat <= 40.000000) && (lat >= 38.660000) && (lon >= -96.000000) && (lon <= -94.000000)) ||
  //     ((lat <= 36.800000) && (lat >= 35.667000) && (lon >= -116.30000) && (lon <= -113.85000)) ||
  //     ((lat <= 34.500000) && (lat >= 33.370000) && (lon >= -120.15000) && (lon <= -116.45000)) ||
  //     ((lat <= 35.800000) && (lat >= 34.400000) && (lon >= -91.150000) && (lon <= -88.700000)) ||
  //     ((lat <= 26.700000) && (lat >= 25.100000) && (lon >= -81.450000) && (lon <= -79.330000)) ||
  //     ((lat <= 45.500000) && (lat >= 44.300000) && (lon >= -94.300000) && (lon <= -92.000000)) ||
  //     ((lat <= 30.600000) && (lat >= 29.550000) && (lon >= -91.500000) && (lon <= -89.300000)) ||
  //     ((lat <= 41.300000) && (lat >= 40.220000) && (lon >= -75.600000) && (lon <= -72.660000)) ||
  //     ((lat <= 29.200000) && (lat >= 27.800000) && (lon >= -82.500000) && (lon <= -80.200000)) ||
  //     ((lat <= 40.500000) && (lat >= 39.383330) && (lon >= -75.916667) && (lon <= -74.516667)) ||
  //     ((lat <= 34.150000) && (lat >= 32.750000) && (lon >= -113.50000) && (lon <= -111.16000)) ||
  //     ((lat <= 41.050000) && (lat >= 39.950000) && (lon >= -81.000000) && (lon <= -79.000000)) ||
  //     ((lat <= 18.760000) && (lat >= 17.630000) && (lon >= -67.750000) && (lon <= -64.220000)) ||
  //     ((lat <= 41.500000) && (lat >= 40.100000) && (lon >= -113.20000) && (lon <= -110.65000)) ||
  //     ((lat <= 33.600000) && (lat >= 32.500000) && (lon >= -117.90000) && (lon <= -116.30000)) ||
  //     ((lat <= 38.200000) && (lat >= 36.900000) && (lon >= -123.80000) && (lon <= -121.36000)) ||
  //     ((lat <= 48.150000) && (lat >= 46.720000) && (lon >= -123.60000) && (lon <= -121.10000)) ||
  //     ((lat <= 39.300000) && (lat >= 38.150000) && (lon >= -91.400000) && (lon <= -89.250000)) ||
  //     ((lat <= 28.570000) && (lat >= 27.250000) && (lon >= -83.300000) && (lon <= -81.850000))){
  //   return 1;
  // }else{
  //   return 0;
  // }
}

int printcoords(int x, int y, int sx, int sy, char* buffer2, float denx, float deny, float latl, float lonl, int level){
  
  float latul = latl + y*sy*deny;
  float latll = latul + sy*deny;
  float latur = latul;
  float latlr = latul + sy*deny;
  float latc  = latul + sy*deny/2;

  float lonul = lonl + x*sx*denx;
  float lonll = lonul;
  float lonur = lonul + sx*denx;
  float lonlr = lonul + sx*denx;
  float lonc  = lonul + sx*denx/2;
  
  printf (
	  // "%s,%10.0g,%g,%g,%g,%g,%g,%g,%g,%g,%g\n", 
	  "%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,,%i\n", 
	  buffer2,
	  lonul, latul, lonll, latll, lonur, latur, lonlr, latlr, lonc, latc, level
	  );

  int ix,iy,n;
  if(level==0){
    n=5;
  }else if(level==1){
    n=10;
  }else if(level==2){
    n=20;
  }else if(level==3){
    n=40;
  }else if(level==4){
    n=80;
  }
  
  // Check if any points in the image fall within the TAC range.
  float latm = (latul-latll)/n;
  float lonm = (lonur-lonul)/n;
  ix=0;
  while (ix<=n){
    iy=0;
    while (iy<=n){
      float lat = latll+latm*iy;
      float lon = lonul+lonm*ix;
      if (tacareas(lon, lat)){
	// printf ("DEBUG inside %g %g %i %i %g,%g to %g,%g\n\n\n\n", lon, lat, ix, iy, lonll, latll, lonur, latur);
	return 1;
      }
      // printf ("DEBUG outside %g %g %i %i %g,%g to %g,%g\n", lon, lat, ix, iy, lonll, latll, lonur, latur);
      iy++;
    }
    ix++;
  }
  
  // printf ("Not in window. %g,%g to %g,%g\n\n", lonll, latll, lonur, latur);
  return 0;
}


int debug=0;
#include "stageall.c"

#define ThrowWanException(wand)  { \
char  *description; \
ExceptionType severity; \
description=MagickGetException(wand,&severity); \
(void) fprintf(stderr,"%s %s %lu %s\n",GetMagickModule(),description); \
description=(char *) MagickRelinquishMemory(description); \
exit(-1); \
}

int main(int argc, char *argv[])
{
  
  char buffer1[1024];
  char buffer2[1024];
  char buffer3[1024];
  
  int numpar;
  int dothis;
  
  if (argc<8){
    printf ("Must pass image, corners top left long lat and bottom right long lag and destination.\n");
    printf ("  \"retile img lonl latl lonr latr dest type numparallel thisparallel\" \n");
    return 1;
  };
  char infile[1024];
  char bfile1[1024];
  char bfile2[1024];
  char dirnam[1024];
  char ftype[5];
  strncpy(infile,argv[1],strlen(argv[1]));

  float lonl=atof(argv[2]);
  float latl=atof(argv[3]);
  float lonr=atof(argv[4]);
  float latr=atof(argv[5]);
  strncpy(dirnam,argv[6],strlen(argv[6]));
  strncpy(ftype,argv[7],strlen(argv[7]));

  // Terminate the strings.  For some reason dirnam doesn't terminate properly
  infile[strlen(argv[1])] = '\0';
  dirnam[strlen(argv[6])] = '\0';
  ftype[strlen(argv[7])] = '\0';
  
  if (argc>=8){
    if (argc==10){
      numpar=atoi(argv[8]);
      dothis=atoi(argv[9]);
    }else{
      numpar=dothis=1;
    }
  }
  
  if (argc>=11){
    debug=1;
  }

  // Create a filename base
  strcpy(bfile1, infile);
  const char s[2] = "/";
  char *token;
  /* get the first token */
  token = strtok(bfile1, s);
  /* walk through other tokens */
  while( token != NULL ) 
    {
      strcpy(bfile2, token);
      token = strtok(NULL, s);
    }
  bfile2[strlen(bfile2)-4]='\0';
  
  printf ("## %s %s\n", infile, dirnam);
  
  int isnottac = strcmp(&infile[strlen(infile)-7],"tac.tif");
  if (!isnottac){printf ("## Input file is the big tac.  Will only output select image files.\n");}
  
  MagickWand *wand_input = NULL;
  MagickWand *wand_temp1 = NULL;
  MagickWand *wand_temp2 = NULL;

  MagickWandGenesis();

  PixelWand *bgcolor = NewPixelWand();
  PixelSetColor(bgcolor, "black");

  int sx = 512;
  int sy = 512;
  int offx = 0;
  int offy = 0;
  
  int x,y,i;
  int idiv;
  
  MagickBooleanType status;
  wand_input = NewMagickWand();
  wand_temp1 = NewMagickWand();
  wand_temp2 = NewMagickWand();
  MagickSetOption(wand_input,"type","Pallete");
  MagickSetOption(wand_temp1,"type","Pallete");
  MagickSetOption(wand_temp2,"type","Pallete");
  // MagickSetOption(wand_input,"storage-type","integers");
  // MagickSetOption(wand_temp1,"storage-type","integers");
  // MagickSetOption(wand_temp2,"storage-type","integers");

  // printf ("# Loading input image.  This may take some time.\n");
  // status = MagickReadImage(wand_input,infile);
  status = MagickPingImage(wand_input,infile);

  if (status == MagickFalse){
    ThrowWanException(wand_input);
  }
  printf ("# Done loading input image in format %s.\n", MagickGetImageFormat(wand_input));
  
  // Get the image's width and height
  int width = MagickGetImageWidth(wand_input);
  int height = MagickGetImageHeight(wand_input);
  if (( width==0 || height==0 )){
    printf ("## Error -- image size is zero\n");
    return 0;
  }
  
  float odenx=(lonr-lonl)/width;
  float odeny=(latr-latl)/height;
  
  int nx = width/sx;
  int ny = height/sy;
  int nbx = width/sx/16;
  int nby = height/sy/16;

  // Don't fail if a small image is passed.
  if (nbx==0){nbx=1;}
  if (nby==0){nby=1;}
  // Gather also the margins when not clean
  if (nbx*sx*16<width){nbx+=1;}
  if (nby*sy*16<height){nby+=1;}

  int tilecount=0;
  int xb,yb;
  int scale;
  
  // printf ("# Big tile set will be %ix%i\n", nbx, nby);
  // DEBUG // for (yb=0; yb<1; yb++){
  // DEBUG //   for (xb=0; xb<1; xb++){
  for (yb=0; yb<nby; yb++){
    for (xb=0; xb<nbx; xb++){
     
      // Small image fixing margins
      int sbx, sby;
      int resizeme=0;
      sbx=sx*16;
      sby=sy*16;
      if (((xb+1)*16*sx)>width){
	sbx=width-xb*sx*16;
	resizeme=1;
      }else{
	sbx=sx*16;
      }
      if (((yb+1)*16*sy)>height){
	sby=height-yb*sy*16;
	resizeme=1;
      }else{
	sby=sy*16;
      }
      
      x=nbx*yb+xb;
      y=nbx*nby;
      float per=((float) x)/((float) y);
      
      // Allow the work tasks to be spread across multiple computers
      // printf ("x %i x mod numpar %i dothis %i", x, x%numpar, dothis);
      if ( (x%numpar+1) == dothis ){
	
	printf ("# %i of %i megatiles read, %0.3f%% complete.  %8i 512x512 tiles written\n", x, y, 100*per, tilecount);
	printf ("# Loading megatile size %ix%i+%i+%i\n", sbx, sby, xb*16*sx, yb*16*sy);

	// Create and load a smaller megatile
	char tmpfname[1024];
	sprintf (tmpfname,"%s%i%i%i%i", infile, xb*16*sx, yb*16*sy, sbx, sby);
	sprintf (buffer1, "gdal_translate -co TILED=YES -q -srcwin %i %i %i %i %s %s.tif", xb*16*sx, yb*16*sy, sbx, sby, infile, tmpfname);
	out(buffer1);
	sprintf (buffer1, "%s.tif", tmpfname);
	status = MagickReadImage(wand_temp1,buffer1);
	if (status == MagickFalse){
	  ThrowWanException(wand_temp1);
	}
	// wand_temp1 = MagickGetImageRegion(wand_input, sbx, sby, xb*16*sx, yb*16*sy);
	
	sprintf (buffer1, "rm -f %s.tif", tmpfname);
	out(buffer1);
	
	int hy = MagickGetImageHeight(wand_temp1);
	int hx = MagickGetImageWidth(wand_temp1);
	if (hx < 2 || hy < 2){
	  printf ("## ERROR in loading megatile, size of image %ix%i, for sbx,sby=%i,%i\n", hx, hy, sbx, sby);
	}	  


	if (resizeme){
	  // MagickSetBackgroundColor(wand_input,bgcolor);
	  // MagickSetBackgroundColor(wand_temp1,bgcolor);
	  // MagickSetBackgroundColor(wand_temp2,bgcolor);
	  printf ("# Pad the megatile so it has the correct dimensions of %ix%i\n", sx*16, sy*16);
	  status = MagickExtentImage(wand_temp1, sx*16, sy*16, 0, 0);
	  if (status == MagickFalse){
	    printf ("# Error padding the megatile\n");
	    ThrowWanException(wand_temp1);
	  }
	}
	printf ("# Done loading megatile.\n");
      
	for (i=0; i<=4; i++){
	  // printf ("i=%i\n",i);
	  scale=(1+i);
	  int b;
	  int newscale=1;
	
	  for (b=1; b<scale; b++){
	    newscale*=2;
	  }
	  scale=newscale;
	  float denx=odenx*scale;
	  float deny=odeny*scale;
 	
	  printf ("# Scaling megatile by 1/%i to %ix%i and tiling as 512x512\n", scale, sx*16/scale, sy*16/scale);
	  if (i>0){
	    MagickResizeImage(wand_temp1, sx*16/scale, sy*16/scale, LanczosFilter, 1);
	    int hy = MagickGetImageHeight(wand_temp1);
	    int hx = MagickGetImageWidth(wand_temp1);
	    if (hx < 2 || hy < 2){
	      printf ("## ERROR rescaling megatile for xb,yb=%i,%i\n", xb, yb);
	    }	  
	  }
 	
#pragma omp parallel for private(buffer1, buffer2, buffer3, x, y, offx, offy, wand_temp2) // schedule(dynamic,1)
	  for (y=yb*16/scale; y<(yb+1)*16/scale; y++){
	    
	    // Create the directory and filename
	    snprintf(buffer1, sizeof(buffer1), "%s/%i/%i", dirnam, i, y+1);
	    snprintf(buffer2, sizeof(buffer2), "[[ -d %s ]] || mkdir -p %s",  buffer1, buffer1);
	    out (buffer2);
	    
	    for (x=xb*16/scale; x<(xb+1)*16/scale; x++){
	      // Assuming no repage is done.
	      offx=x*sx;
	      offy=y*sy;
	      
	      // Now correct since we have only pulled a smaller megatile
	      offx=offx-xb*sx*16/scale;
	      offy=offy-yb*sy*16/scale;
	      
	      // printf ("Grabbing %ix%i+%i+%i of %ix%i ", sx, sy, offx, offy, sx*16/scale, sy*16/scale);
	      snprintf(buffer2, sizeof(buffer2), "%s/%s_%03d_%03d.%s", buffer1, bfile2, y+1, x+1, ftype);
	      
	      // snprintf(buffer2, sizeof(buffer2), "%s/tac_%03d_%03d.png", buffer1, y+1, x+1);
	      
	      if (printcoords(x, y, sx, sy, buffer2, denx, deny, latl, lonl, i) || isnottac){
		// wand_temp2 = MagickGetImageRegion(wand_temp1, sx, sy, offx, offy);
		wand_temp2 = MagickGetImageRegion(wand_temp1, sx, sy, offx, offy);
		int hy = MagickGetImageHeight(wand_temp2);
		int hx = MagickGetImageWidth(wand_temp2);
		
		// Make sure it is the correct colorspace
		if (hx < 2 || hy < 2){
		  printf ("## ERROR in loading minitile, size of image %ix%i, for xb,yb=%i,%i, x,y=%i,%i, offx,offy=%i,%i, scale=%i\n", 
			  hx, hy, xb, yb, x, y, offx, offy, scale);
		}else{
		  int ispng = strncmp(ftype,"png",3);
		  
		  // Write png file first then convert if necessary
		  // snprintf(buffer3, sizeof(buffer3), "png8:%s", buffer2);
		  snprintf(buffer3, sizeof(buffer3), "png:%s", buffer2);
		  MagickWriteImage(wand_temp2,buffer3);
		  
		  char cmdstr[4096];
		  snprintf (cmdstr, sizeof(cmdstr), "if [[ `identify -format %k %s` == 1 ]]; then rm -f %s; else ", buffer2, buffer2);

		  if ( ispng == 0 ){
		    // Repage and optimize.
		    snprintf (buffer3, sizeof(buffer3), "convert +repage %s png8:%s.png;", buffer2, buffer2);
		    strcat (cmdstr, buffer3);
		    snprintf (buffer3, sizeof(buffer3), "mv %s.png %s;", buffer2, buffer2);
		    strcat (cmdstr, buffer3);
		    snprintf (buffer3, sizeof(buffer3), "optipng -silent %s;", buffer2);
		    strcat (cmdstr, buffer3);
		  }else{
		    snprintf (buffer3, sizeof(buffer3), "mogrify +repage -antialias -unsharp 0x3 -quality 50 %s;", buffer2);
		    strcat (cmdstr, buffer3);
		  }
		  
		  snprintf (buffer3, sizeof(buffer3), "fi");
		  strcat (cmdstr, buffer3);
		  out (cmdstr);
		  // printf ("%s", cmdstr);
		}
		tilecount++;
	      }
	    }
	  }
	}
      }
    }
  }
  
  // Clean up
  if(wand_input)wand_input = DestroyMagickWand(wand_input);
  if(wand_temp1)wand_temp1 = DestroyMagickWand(wand_temp1);
  if(wand_temp2)wand_temp2 = DestroyMagickWand(wand_temp2);
  MagickWandTerminus();

  return 0;
}
