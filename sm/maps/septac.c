/*
Copyright (c) 2012, Zubair Khan (governer@gmail.com) 
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    *     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    *
    *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include<stdio.h>
#include <string.h>
#include <stdlib.h>

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
  char buffer[1024];
  char *n_ptr;
  char *dirstr;

  if (argc==3){debug=1;}
  if (argc==1){
    printf ("Must pass cycle number.\n");
    return 1;
  };
  printf ("Cycle %s\n",argv[1]);

  int entries = sizeof(maps) / sizeof(maps[0]);

  for(map = 0; map < entries; map++) {
    n_ptr = maps[map].name;
    dirstr = "tac";

    // Remove any existing zip files
    snprintf(buffer, sizeof(buffer),
	     "if [[ -f final/%s.zip ]]; then rm final/%s.zip; fi",
	     n_ptr, n_ptr);
    out(buffer);

    // Create zip files
    snprintf(buffer, sizeof(buffer),
	     "zip final/%s.zip -r -9 -T -q `sqlite3 maps.%s.db \"select name from files where (latc <= %f) and (latc >= %f) and (lonc >= %f) and (lonc <= %f) and (level != ' 4') and name like '%%tiles/%s/%s%%';\"`", 
	     n_ptr, dirstr, maps[map].latu, maps[map].latd, maps[map].lonl, maps[map].lonr, argv[1], dirstr);
    out(buffer);

    // Update database
    snprintf(buffer, sizeof(buffer),
	     "sqlite3 maps.%s.db \"update files set info='%s' where (latc <= %f) and (latc >= %f) and (lonc >= %f) and (lonc <= %f) and name like '%%tiles/%s/%s%%';\"",
	     dirstr, n_ptr, maps[map].latu, maps[map].latd, maps[map].lonl, maps[map].lonr, argv[1], dirstr);

    out(buffer);
    out("\n\n");
  }
	
  return 0;
}
