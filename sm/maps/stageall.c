#include "stageall.h"

void out(char *buffer){
  int i=0;
  int count=0;
  if (debug){
    printf ("%s\n",buffer);
  }else{
    // printf ("%s\n",buffer);
    i=system(buffer);
    while(i){
      if (count<3){
	printf("Attempt %i failed, reattempting:\n",count++);
	printf("Attempted command: %s\n",buffer);
      }else{
	return;
      }
      i=system(buffer);
    }
  }
}


int checkblack (char *imagefile) {
  char buffer[512]; 
  snprintf(buffer, sizeof(buffer), "./checkblack.sh %s\n", imagefile);

  if (debug){
    printf ("#Checkblack %s\n%s\n",imagefile,buffer);
  }else{
    FILE *fp;
    fp = popen(buffer, "r");
    if (fp == NULL) {printf("Quality control failed for %s.\n", imagefile);}

    char qcstr[40];
    fgets(qcstr, sizeof(qcstr), fp);
    pclose(fp);
    float f=atof(qcstr);
    printf("#The ratio of black to total pixels in %s is %g\n", imagefile, f);
    if (f>0.25) {
      printf ("Rerun %s\n", imagefile);
      return 1;
    }
  }
  return 0;
}
