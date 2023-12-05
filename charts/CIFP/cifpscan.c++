#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "cifpscan.h"

// static const int linelength = 132;
static const int linelength = 1000;


int continuation(char *line, int l){  
  return atoi(line+l);
}

int endofsegment(char *line, int l){  
  if (!strncmp(line+l,"E",1)){  // End of Continous Segment
    return 1;
  }
  return 0;
}


APPROACH_T approach;
AIRPORT_T emptyairport;

AIRPORT_T airport;
APPROACH_T emptyapproach;


int AirportRecordPrimary (char *line){
  int n=0;
  mystrncpy (airport.RecordType, line, &n, 1, false);
  mystrncpy (airport.CustomerAreaCode, line, &n, 3, false);
  mystrncpy (airport.SectionCode, line, &n, 1, false);
  mystrncpy (airport.BlankSpacing, line, &n, 1, false);
  mystrncpy (airport.AirportICAOIdentifier, line, &n, 4, false);
  mystrncpy (airport.ICAOCode1, line, &n, 2, false);
  mystrncpy (airport.SubsectionCode, line, &n, 1, false);
  mystrncpy (airport.ATAIATADesignator, line, &n, 3, false);
  mystrncpy (airport.ReservedExpansion1, line, &n, 2, false);
  mystrncpy (airport.BlankSpacing, line, &n, 3, false);
  mystrncpy (airport.ContinuationRecordNo, line, &n, 1, false);
  mystrncpy (airport.SpeedLimitAltitude, line, &n, 5, false);
  mystrncpy (airport.LongestRunway, line, &n, 3, false);
  mystrncpy (airport.IFRCapability, line, &n, 1, false);
  mystrncpy (airport.LongestRunwaySurfaceCode, line, &n, 1, false);
  mystrncpy (airport.AirportReferencePtLatitude, line, &n, 9, false);
  mystrncpy (airport.AirportReferencePtLongitude, line, &n, 10, false);
  mystrncpy (airport.MagneticVariation, line, &n, 5, false);
  mystrncpy (airport.AirportElevation, line, &n, 5, false);
  mystrncpy (airport.SpeedLimit, line, &n, 3, false);
  mystrncpy (airport.RecommendedNavaid, line, &n, 4, false);
  mystrncpy (airport.ICAOCode2, line, &n, 2, false);
  mystrncpy (airport.TransitionsAltitude, line, &n, 5, false);
  mystrncpy (airport.TransitionLevel, line, &n, 5, false);
  mystrncpy (airport.PublicMilitaryIndicator, line, &n, 1, false);
  mystrncpy (airport.TimeZone, line, &n, 3, false);
  mystrncpy (airport.DaylightIndicator, line, &n, 1, false);
  mystrncpy (airport.MagneticTrueIndicator, line, &n, 1, false);
  mystrncpy (airport.DatumCode, line, &n, 3, false);
  mystrncpy (airport.ReservedExpansion2, line, &n, 4, false);
  mystrncpy (airport.AirportName, line, &n, 30, false);
  mystrncpy (airport.FileRecordNumber, line, &n, 5, false);
  mystrncpy (airport.CycleDate, line, &n, 4, false);
}

int AirportRecordContinuation (char *line){
  int n=0;
  mystrncpy (airport.RecordType, line, &n, 1, false);
  mystrncpy (airport.CustomerAreaCode, line, &n, 3, false);
  mystrncpy (airport.SectionCode, line, &n, 1, false);
  mystrncpy (airport.BlankSpacing, line, &n, 1, false);
  mystrncpy (airport.AirportICAOIdentifier, line, &n, 4, false);
  mystrncpy (airport.ICAOCode1, line, &n, 2, false);
  mystrncpy (airport.SubsectionCode, line, &n, 1, false);
  mystrncpy (airport.ATAIATADesignator, line, &n, 3, false);
  mystrncpy (airport.ReservedExpansion1, line, &n, 2, false);
  mystrncpy (airport.BlankSpacing, line, &n, 3, false);
  mystrncpy (airport.ContinuationRecordNo, line, &n, 1, false);
  mystrncpy (airport.ReservedSpacing, line, &n, 1, false);
  mystrncpy (airport.Notes, line, &n, 69, false);
  mystrncpy (airport.ReservedExpansion3, line, &n, 31, false);
  mystrncpy (airport.FileRecordNo, line, &n, 5, false);
  mystrncpy (airport.CycleDate, line, &n, 4, false);
}    


int ApproachRecord (char *line, std::ofstream& approachfile){
  int cont=continuation(line,38);

  // Gather the data from the file
  if (cont<0 || cont==3){
    
    printf ("ERROR.  Unexpected continuation");
    
  }else if (cont==0){
    
    approach.ApproachRecordPrimary (line);
    approach.printprimary();
    
  }else if (cont==1){
      
    approach.ApproachRecordPrimary (line);
    approach.printprimary();
    
  }else if (cont==2){
    
    approach.ApproachRecordDataContinuation (line);
    approach.printdatacontinuation();

  }


  // The data is gathered, now do the work.
  // Is this line a transition line?
  int trans = (approach.route_type()==1);

  // Has the missed approach point been reached?
  std::string MAP=approach.WaypointDescriptionCode;
  if (!MAP.compare("  M ")){approach.imissedpass=1;}
  
  if (approach.ifirstpass){
    approach.ifirstpass=0;
    
    // First pass for this type of data
    approach.finalsequence.Airport = approach.AirportIdentifier;
    approach.finalsequence.Runway = approach.SIDSTARApproachIdentifier;
  }
  
  if (trans) {
    
    // .push_back is c++ std::string function to add to the back of
    // the string
    // approach.transitions[transnum].Airport = approach.AirportIdentifier;
    // approach.transitions[transnum].Runway = approach.SIDSTARApproachIdentifier;
    // approach.transitions[transnum].seqnumber.push_back(approach.iSequenceNumber);
    int transnum = approach.itransitionNumber;
    if (transnum<100){
      approach.transitions[transnum].FlightPlan += approach.FixIdentifier;
      approach.transitions[transnum].FlightPlan += ",";
      approach.transitions[transnum].Altitude += approach.Altitude1;
      approach.transitions[transnum].Altitude += ",";
      approach.transitions[transnum].seqnumber.push_back(approach.iSequenceNumber);
    }else{
      std::cout << "WARNING too many transitions for allocated space. ";
      std::cout << transnum;
    }

  }else if (approach.imissedpass==1){
    approach.missedsequence.FlightPlan += approach.FixIdentifier;
    approach.missedsequence.FlightPlan += ",";
    approach.missedsequence.Altitude += approach.Altitude1;
    approach.missedsequence.Altitude += ",";
    approach.missedsequence.seqnumber.push_back(approach.iSequenceNumber);
  }else{
    approach.finalsequence.FlightPlan += approach.FixIdentifier;
    approach.finalsequence.FlightPlan += ",";
    approach.finalsequence.Altitude += approach.Altitude1;
    approach.finalsequence.Altitude += ",";
    approach.finalsequence.seqnumber.push_back(approach.iSequenceNumber);
  }
  
  if (approach.iCycleDate>approach.iLatestCycleDate){
    approach.iLatestCycleDate = approach.iCycleDate;
  }

  
  // Do this only on the last segment
  int endofapproach = (approach.route_type()==2 || approach.route_type()==3);

  // Print out the actual sequences
  if ((endofsegment(line,40)) && endofapproach){
    for (int i=0;i<=approach.itransitionNumber;i++){

      // General info about the approach
      approachfile << approach.AirportIdentifier << "|";
      approachfile << approach.RouteType << "|";
      approachfile << approach.SIDSTARApproachIdentifier << "|";
      approachfile << approach.iLatestCycleDate << "|";

      // // Sequence numbers if interested
      // for (int j = 0; j < approach.transitions[i].seqnumber.size(); j++) {
      //   approachfile << approach.transitions[i].seqnumber[j];
      //   approachfile << ",";
      // }
      // for (int j = 0; j < approach.finalsequence.seqnumber.size(); j++) {
      // 	approachfile << approach.finalsequence.seqnumber[j];
      //   approachfile << ",";
      // }
      // approachfile << "|";
	
      // FlightPaths
      approachfile << approach.transitions[i].FlightPlan << "|";
      approachfile << approach.transitions[i].Altitude << "|";

      approachfile << approach.finalsequence.FlightPlan << "|";
      approachfile << approach.finalsequence.Altitude << "|";

      approachfile << approach.missedsequence.FlightPlan << "|";
      approachfile << approach.missedsequence.Altitude;

      approachfile << "\n";

      // Clean things up
      approach.transitions[i].FlightPlan.clear();
      approach.transitions[i].seqnumber.clear();
      approach.transitions[i].Altitude.clear();
    }
    approach = emptyapproach;
  }
}

int AirportRecord (char *line, std::ofstream& approachfile){
  
  // Check for subsectioncode
  int n=12;
  char SubsectionCode[1];
  mystrncpy (SubsectionCode, line, &n, 1, false);
  
  if (!strncmp(SubsectionCode, "A", 1)){ // Reference Points
  }else if (!strncmp(SubsectionCode, "B", 1)){ // Gates
  }else if (!strncmp(SubsectionCode, "C", 1)){ // Terminal Waypoints
  }else if (!strncmp(SubsectionCode, "D", 1)){ // SIDs
  }else if (!strncmp(SubsectionCode, "E", 1)){ // STARs
  }else if (!strncmp(SubsectionCode, "F", 1)){ // Approach Procedures 
    ApproachRecord (line, approachfile);
  }else if (!strncmp(SubsectionCode, "G", 1)){ // Runways
  }else if (!strncmp(SubsectionCode, "I", 1)){ // Localizer/Glide Slope 
  }else if (!strncmp(SubsectionCode, "L", 1)){ // MLS
  }else if (!strncmp(SubsectionCode, "M", 1)){ // Localizer Marker	
  }else if (!strncmp(SubsectionCode, "N", 1)){ // Terminal NDB	
  }else if (!strncmp(SubsectionCode, "P", 1)){ // Pathpoint
  }else if (!strncmp(SubsectionCode, "R", 1)){ // Flt Planning ARR/DEP
  }else if (!strncmp(SubsectionCode, "S", 1)){ // MSA
  }else if (!strncmp(SubsectionCode, "T", 1)){ // GLS Station	
  }else if (!strncmp(SubsectionCode, "V", 1)){ // Communications
  }else if (!strncmp(SubsectionCode, " ", 1)){ // EMPTY
    printf ("Empty SubSection Code %s\n", SubsectionCode);
  }else{
    
    printf ("Unknown SubSection Code %s\n", SubsectionCode);
    printf ("Probably primary record %s\n", SubsectionCode);

    // Check if the obtained line is a continuation or new record
    int cont = continuation(line, 21);
    if (cont){
      // Update the old record
      AirportRecordContinuation (line);
    }else{
      // Start a new record
      airport = emptyairport;
      AirportRecordPrimary (line);
    }
  }
}


int main ( int argc, char* argv[] ){

  // char filename[] = "CIFP_201608/FAACIFP18";
  char* filename;
  if (argc<2){
    printf ("1 argument required\n");
    exit(1);
  } else {
    filename = argv[1];
    // printf ("%s\n", filename);
    // exit(0);
  }
  FILE *file = fopen ( filename, "r" );
  
  std::ofstream approachfile;
  approachfile.open ("approaches.txt"); // , std::ios::app
 
  if (file != NULL) {
    
    // Declare a continuation record.
    int cont = 0;
     
    char line [linelength];
    while(fgets(line, linelength, file)!= NULL){ /* read a line from a file */

      int n=0;
      char RecordType [1]; // 1
      char CustomerAreaCode [3]; // 2 thru 4
      char SectionCode [1]; // 5
      mystrncpy (RecordType, line, &n, 1, false);
      mystrncpy (CustomerAreaCode, line, &n, 3, false);
      mystrncpy (SectionCode, line, &n, 1, false);
           
      if (!strncmp(RecordType, "S", 1)){
     	if (!strncmp(SectionCode, "A", 1)){ // MORA
     	}else if (!strncmp(SectionCode, "D", 1)){ // NAVAID
     	  //VHFNAVAIDRecord (&line, &file);
     	}else if (!strncmp(SectionCode, "E", 1)){ // Enroute
     	  // EnRouteRecord (&line, &file);
     	}else if (!strncmp(SectionCode, "H", 1)){ // Heliport
     	}else if (!strncmp(SectionCode, "P", 1)){ // Airport
	  AirportRecord (line, approachfile);
     	}else if (!strncmp(SectionCode, "R", 1)){ // Company Route
     	  // CompanyRecord (&line, &file);
     	}else if (!strncmp(SectionCode, "T", 1)){ // Table
     	}else if (!strncmp(SectionCode, "U", 1)){ // Airspace
     	}else{
     	  printf ("Unknown Section Code\n");
     	}
      }else if(!strncmp(RecordType, "T", 1)){ // Tailored
      }else{
     	printf ("Unknown Record Type\n");
      }
    }
    approachfile.close();
    fclose(file);
  }
  else{
    perror(filename);
  }
  
  return 0;
}


// int VHFNAVAIDRecord (char *line, FILE *file){  
//   int n=0;
//   char RecordType [1];
//   char CustomerAreaCode [3];
//   char SectionCode [1];
//   char SubsectionCode [1];
//   char AirportICAOIdentifier [4];
//   char ICAOCode1 [2];
//   char BlankSpacing [1];
//   char VORIdentifier [4];
//   char BlankSpacing2 [2];
//   char ICAOCode2 [2];
//   char ContinuationRecordNo [1];
//   char VORFrequency [5];
//   char NAVAIDClass [5];
//   char VORLatitude [9];
//   char VORLongitude [10];
//   char DMEIdent [4];
//   char DMELatitude [9];
//   char DMELongitude [10];
//   char StationDeclination [5];
//   char DMEElevation [5];
//   char FigureofMerit [1];
//   char ILSDMEBias [2];
//   char FrequencyProtection [3];
//   char DatumCode [3];
//   char VORName [30];
//   char FileRecordNo [5];
//   char CycleDate [4];
//   mystrncpy (RecordType, line, &n, 1, false);
//   mystrncpy (CustomerAreaCode, line, &n, 3, false);
//   mystrncpy (SectionCode, line, &n, 1, false);
//   mystrncpy (SubsectionCode, line, &n, 1, false);
//   mystrncpy (AirportICAOIdentifier, line, &n, 4, false);
//   mystrncpy (ICAOCode1, line, &n, 2, false);
//   mystrncpy (Blanksplacing1, line, &n, 1, false);
//   mystrncpy (VORIdentifier, line, &n, 4, false);
//   mystrncpy (BlankSpacing2, line, &n, 2, false);
//   mystrncpy (ICAOCode2, line, &n, 2, false);
//   mystrncpy (ContinuationRecordNo, line, &n, 1, false); 
//   mystrncpy (VORFrequency, line, &n, 5, false);
//   mystrncpy (NAVAIDClass, line, &n, 5, false);
//   mystrncpy (VORLatitude, line, &n, 9, false);
//   mystrncpy (VORLongitude, line, &n, 10, false);
//   mystrncpy (DMEIdent, line, &n, 4, false);
//   mystrncpy (DMELatitude, line, &n, 9, false);
//   mystrncpy (DMELongitude, line, &n, 10, false);
//   mystrncpy (StationDeclination, line, &n, 5, false);
//   mystrncpy (DMEElevation, line, &n, 5, false);
//   mystrncpy (FigureofMerit, line, &n, 1, false);
//   mystrncpy (ILSDMEBias, line, &n, 2, false);
//   mystrncpy (FrequencyProtection, line, &n, 3, false);
//   mystrncpy (DatumCode, line, &n, 3, false);
//   mystrncpy (VORName, line, &n, 30, false);
//   mystrncpy (FileRecordNo, line, &n, 5, false);
//   mystrncpy (CycleDate, line, &n, 4, false);
// 
//   while (strncmp(ContinuationRecordNo, "0", 1)){
//     fgets(line, linelength, file);
//     char FieldsasonPrimaryRecords[21];
//     // char ContinuationRecordNo[1];
//     char ReservedSpacing[1];
//     char Notes[69];
//     char Reservedexpansion[31];
//     char FileRecordNo[5];
//     char CycleDate[4];
// 
//     n=0;
//     mystrncpy (FieldsasonPrimaryRecords, line, &n, 21, false); // 1 thru 21
//     mystrncpy (ContinuationRecordNo, line, &n, 1, false); // 22
//     mystrncpy (ReservedSpacing, line, &n, 1, false); // 23
//     mystrncpy (Notes, line, &n, 69, false); // 24 thru 92
//     mystrncpy (Reservedexpansion, line, &n, 31, false); // 93 thru 123
//     mystrncpy (FileRecordNo, line, &n, 5, false); //124 thru 128
//     mystrncpy (CycleDate, line, &n, 4, false); //129 thru 132
//   }
// }
// 
// int EnRouteRecord (char *line, FILE *file){}
// int CompanyRecord (char *line, FILE *file){}

// int cycledate_to_cycle (char *dest, char *line){  
//   strncpy(dest, line, 4);
// }
