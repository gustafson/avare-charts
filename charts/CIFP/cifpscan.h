#include <iostream>
#include <fstream>
#include <vector>

int mystrncpy(char *dest, char *line, int *n, int l, int print){
  strncpy(dest, line+*n, l);
  // Terminate the copied string.
  dest[l]='\0';
  *n+=l;
  if (print){
    printf ("%s,", dest);
  }
}

#if 0
#define verbose(a) printf a
#define vstrappend(a,b) strcpy(a+strlen(a),b)
#else
#define verbose(a) (void)0
#define vstrappend(a,b) (void)0
#endif

// typedef struct transition_t {
//   std::string Airport;
//   std::string Runway;
//   std::string FlightPlan;
//   std::string Altitude;
// } TRANSITION_T;

typedef struct sequence_t {
  std::string Airport;
  std::string Runway;
  std::string FlightPlan;
  std::string Altitude;
  std::vector<int> seqnumber;
} SEQUENCE_T;

typedef struct airport_t{ 
  // NOT UPDATED TO -20

  // Add the real record length to one to store the string terminator
  char RecordType[40];
  char CustomerAreaCode[40];
  char SectionCode[40];
  // char BlankSpacing[40];
  char AirportICAOIdentifier[40];
  char ICAOCode1[40];
  char SubsectionCode[40];
  char ATAIATADesignator[40];
  char ReservedExpansion1[40];
  char BlankSpacing[40];
  char ContinuationRecordNo[40];
  char SpeedLimitAltitude[40];
  char LongestRunway[40];
  char IFRCapability[40];
  char LongestRunwaySurfaceCode[40];
  char AirportReferencePtLatitude[40];
  char AirportReferencePtLongitude[40];
  char MagneticVariation[40];
  char AirportElevation[40];
  char SpeedLimit[40];
  char RecommendedNavaid[40];
  char ICAOCode2[40];
  char TransitionsAltitude[40];
  char TransitionLevel[40];
  char PublicMilitaryIndicator[40];
  char TimeZone[40];
  char DaylightIndicator[40];
  char MagneticTrueIndicator[40];
  char DatumCode[40];
  char ReservedExpansion2[40];
  char AirportName[30+1];
  char FileRecordNumber[40];
  char CycleDate[40];

  // For continuations
  char FieldasonPrimaryRecords[40];
  // char ContinuationRecordNo[40];
  char ReservedSpacing[40];
  char Notes[80];
  char ReservedExpansion3[40];
  char FileRecordNo[40];
  //char CycleDate[40];
} AIRPORT_T;

class TRANSITION{
 public:
};


class APPROACH_T{
  // 4.1.9.1 on page 51.

  // It appears that each transition option shows up with its initial
  // fix and last fix prior to FAF. 

  // KAZO R35 goes 
  // Options for Transitions
  //   AZO-COVAV-(proceedure turn)-COVAV (3 records in a sequence)
  //   YARUD-COVAV (2 records in a sequence)
  // Finals
  //   Eyola-RWY-(missed)-OSEGO-(hold)-OSEGO (4 records in a sequence)

  // Each segment starts with a low sequence number and increases to
  // the end of the segment where everything from FAF to MAP is in one
  // segment.  The plate has a minimum of 2 segments defined but could
  // be more if there is more than one transition.

 public:
  
  SEQUENCE_T * transitions = new SEQUENCE_T[100];
  SEQUENCE_T finalsequence;
  SEQUENCE_T missedsequence;

  int itransitionNumber;
  int iSequenceNumber;
  int ifirstpass;
  int imissedpass;

  // NOT UPDATED TO -20
  char RecordType[40];
  char CustomerAreaCode[40];
  char SectionCode1[40];
  char BlankSpacing1[40];
  char AirportIdentifier[40];
  char ICAOCode1[40];
  char SubsectionCode1[40];
  char SIDSTARApproachIdentifier[40];
  char RouteType[40];
  char TransitionIdentifier[40];
  char ProcedureDesignAircraftCategoryorType[40];
  char SequenceNumber[40];
  char FixIdentifier[40];
  char ICAOCode2[40];
  char SectionCode2[40];
  char SubsectionCode2[40];
  char ContinuationRecordNo[40];
  char WaypointDescriptionCode[40];
  char TurnDirection[40];
  char RNP1[40];
  char PathandTermination[40];
  char TurnDirectionValid[40];
  char RecommendedNavaid[40];
  char ICAOCode3[40];
  char ARCRadius[40];
  char Theta[40];
  char Rho[40];
  char MagneticCourse[40];
  char RouteDistanceHoldingDistanceorTime[40];
  char RECDNAVSection[40];
  char RECDNAVSubsection[40];
  char InboundOutbound[40];
  char Reservedexpansion1[40];
  char AltitudeDescription[40];
  char ATCIndicator[40];
  char Altitude1[40];
  char Altitude2[40];
  char TransitionAltitude[40];
  char SpeedLimit[40];
  char VerticalAngle[40];
  char CenterFix[40];
  char MultipleCode[40];
  char ICAOCode4[40];
  char SectionCode3[40];
  char SubsectionCode3[40];
  char GPSFMSIndication[40];
  char BlankSpacing2[40];
  char ApchRouteQualifier1a[40];
  char ApchRouteQualifier2a[40];
  char BlankSpacing3[40];
  char FileRecordNumber1[40];
  char CycleDate[40];
  int iCycleDate;
  int iLatestCycleDate;
  // OBSOLETE // // Continuation FIELDS
  // OBSOLETE // char FieldasonPrimaryRecords[40];
  // OBSOLETE // char ReservedSpacing[40];
  // OBSOLETE // char CATADecisionHeight[40];
  // OBSOLETE // char CATBDecisionHeight[40];
  // OBSOLETE // char CATCDecisionHeight[40];
  // OBSOLETE // char CATDDecisionHeight[40];
  // OBSOLETE // char CATAMinimumDescentAltitude[40];
  // OBSOLETE // char CATBMinimumDescentAltitude[40];
  // OBSOLETE // char CATCMinimumDescentAltitude[40];
  // OBSOLETE // char CATDMinimumDescentAltitude[40];
  // OBSOLETE // char BlankSpacing4[40];
  // OBSOLETE // char ProcedureCategory[40];
  // OBSOLETE // char RNP2[40];
  // OBSOLETE // char Reservedexpansion2[40];
  // OBSOLETE // char ApchRouteQualifier1b[40];
  // OBSOLETE // char ApchRouteQualifier2b[40];
  // OBSOLETE // char BlankSpacing5[40];
  // OBSOLETE // char FileRecordNumber2[40];
  // OBSOLETE // char CycleDate[40];

  // Data Continuation FIELDS
  char FieldasonPrimaryRecords[40];
  char APPLTYPE[40];
  char FASBLOCK[40];
  char FASBLOCKServiceName[40];
  char LNAVVNAV[40];
  char LNAVVNAVServiceName[40];
  char LNAVforSBAS[40];
  char LNAVServiceName[40];
  char BlankSpacing9[40];
  char RNPAUTH1[40];
  char RNPSERV1[40];
  char RNPAUTH2[40];
  char RNPSERV2[40];
  char RNPAUTH3[40];
  char RNPSERV3[40];
  char RNPAUTH4[40];
  char RNPSERV4[40];
  char APPRTETypeQ1[40];
  char APPRTETypeQ2[40];
  char FileRecordNumber3[40];
  // char CycleDate[40];

  char returnstr[80];

  APPROACH_T(){
    iSequenceNumber=-9999;
    ifirstpass=1;
    iLatestCycleDate=0;
    itransitionNumber=-1;
    imissedpass-1;
  }; // Constructor

//  ~APPROACH_T(){
//    delete[] transitions;
//  }; // Destructor

  void printheader() {
    printf ("\n");
    // printf("%s,", RecordType);
    // printf("%s,", CustomerAreaCode);
    // printf("%s,", SectionCode1);
    // printf("%s,", BlankSpacing1);
    printf("%s,", AirportIdentifier);
    // printf("%s,", ICAOCode1);
    // printf("%s,", SubsectionCode1);                     

    verbose (("Approach ID "));
    printf("%s,", SIDSTARApproachIdentifier);

    if (route_type()==1){
      if (iSequenceNumber==10){                         
	itransitionNumber++;
      } else if (iSequenceNumber==20 && itransitionNumber==-1){
	itransitionNumber++;
	std::cout << "\n" << itransitionNumber << " WARNING THIS IS A PATCH ATTEMPT FOR A POTENTIAL CIFP BUG \n";
      }
    }

    printf("%s,", RouteType);                              

    printf("%s,", TransitionIdentifier);                   
    transition_identifier();

    printf("%s,", ProcedureDesignAircraftCategoryorType);

    verbose (("Seq# "));
    printf("%i,", iSequenceNumber);                         
    printf("%s,", FixIdentifier);
    printf("%s,", ICAOCode2);
    printf("%s,", SectionCode2);
    printf("%s,", SubsectionCode2);
  }

  void printprimary() {
    printheader();

    verbose (("Seq# "));
    printf("%s,", ContinuationRecordNo);

    if (waypoint_description_code()){
      
    };
    printf("%s,", WaypointDescriptionCode);

    verbose(("TurnDir "));
    printf(" %s,", TurnDirection);

    verbose(("RNP "));
    printf("%s,", RNP1);

    printf("%s,", PathandTermination);
    printf("%s,", TurnDirectionValid);

    verbose(("NavAID "));
    printf("%s,", RecommendedNavaid);

    // printf("%s,", ICAOCode3);

    verbose(("ArcRad "));
    printf("%s,", ARCRadius);

    verbose(("ArcTheta "));
    printf("%s,", Theta);

    verbose(("Rho "));
    printf("%s,", Rho);

    verbose(("MagCourse "));
    printf("%s,", MagneticCourse);

    verbose(("Dist "));
    printf("%s,", RouteDistanceHoldingDistanceorTime);

    printf("%s,", RECDNAVSection);
    printf("%s,", RECDNAVSubsection);

    verbose(("INBOUND/OUTBOUND ?"));
    printf("%s,", InboundOutbound);

    // printf("%s,", Reservedexpansion1);

    verbose(("AltDes "));
    printf("%s,", AltitudeDescription);

    verbose(("ATCIndicator "));
    printf("%s,", ATCIndicator);

    verbose(("Alt1 "));
    printf("%s,", Altitude1);
    verbose(("Alt2 "));
    printf("%s,", Altitude2);
    verbose(("AltTrans "));
    printf("%s,", TransitionAltitude);

    verbose(("SpeedLim "));
    printf("%s,", SpeedLimit);

    verbose(("Slope "));
    printf("%s,", VerticalAngle);

    verbose(("CenterFix "));
    printf("%s,", CenterFix);
    // printf("%s,", MultipleCode);
    // printf("%s,", ICAOCode4);
    // printf("%s,", SectionCode3);
    // printf("%s,", SubsectionCode3);
    printf("%s,", GPSFMSIndication);

    // verbose(("Blank "));
    // printf("%s,", BlankSpacing2);
    printf("%s,", ApchRouteQualifier1a);
    printf("%s,", ApchRouteQualifier2a);

    // verbose(("Blank "));
    // printf("%s,", BlankSpacing3);
    // printf("%s,", FileRecordNumber1);
    printf("%i", iCycleDate);
  }

  // OBSOLETE // void printcontinuation() {
  // OBSOLETE //   // printf("%s,", FieldasonPrimaryRecords);
  // OBSOLETE //   printf(",");
  // OBSOLETE //   printf("%s,", ContinuationRecordNo);
  // OBSOLETE //   printf("%s,", CATADecisionHeight);
  // OBSOLETE //   printf("%s,", CATBDecisionHeight);
  // OBSOLETE //   printf("%s,", CATCDecisionHeight);
  // OBSOLETE //   printf("%s,", CATDDecisionHeight);
  // OBSOLETE //   printf("%s,", CATAMinimumDescentAltitude);
  // OBSOLETE //   printf("%s,", CATBMinimumDescentAltitude);
  // OBSOLETE //   printf("%s,", CATCMinimumDescentAltitude);
  // OBSOLETE //   printf("%s,", CATDMinimumDescentAltitude);
  // OBSOLETE //   printf("%s,", BlankSpacing4);
  // OBSOLETE //   printf("%s,", ProcedureCategory);
  // OBSOLETE //   printf("%s,", RNP2);
  // OBSOLETE //   printf("%s,", Reservedexpansion2);
  // OBSOLETE //   printf("%s,", ApchRouteQualifier1b);
  // OBSOLETE //   printf("%s,", ApchRouteQualifier2b);
  // OBSOLETE //   printf("%s,", BlankSpacing5);
  // OBSOLETE //   printf("%s,", FileRecordNumber2);
  // OBSOLETE //   printf("%i", iCycleDate);
  // OBSOLETE // }

  void printdatacontinuation() {
    // printf("%s,", AirportIdentifier);
    // printf("%s,", FieldasonPrimaryRecords);
    printf(",");
    printf("%s,", APPLTYPE);
    printf("%s,", FASBLOCK); // Final Approach Segment Data Block/  Appears different in 18 than in 20.
    printf("%s,", FASBLOCKServiceName);
    printf("%s,", LNAVVNAV);
    printf("%s,", LNAVVNAVServiceName);
    printf("%s,", LNAVforSBAS);
    printf("%s,", LNAVServiceName); // Appears to have runway heading in 18.
    // printf("BLANK %s,", BlankSpacing9);
    // printf("For Expansion %s,", RNPAUTH1);
    // printf("For Expansion %s,", RNPSERV1);
    // printf("For Expansion %s,", RNPAUTH2);
    // printf("For Expansion %s,", RNPSERV2);
    // printf("For Expansion %s,", RNPAUTH3);
    // printf("For Expansion %s,", RNPSERV3);
    // printf("For Expansion %s,", RNPAUTH4);
    // printf("For Expansion %s,", RNPSERV4);
    printf("%s,", APPRTETypeQ1);
    printf("%s,", APPRTETypeQ2);
    // printf("BLANK %s,", BlankSpacing9);
    // printf("%s,", FileRecordNumber3);
    printf("%i", iCycleDate);
  }

  int ApproachRecordPrimary (char *line){
    int n=0;
    mystrncpy (RecordType, line, &n, 1, false);
    mystrncpy (CustomerAreaCode, line, &n, 3, false);
    mystrncpy (SectionCode1, line, &n, 1, false);
    mystrncpy (BlankSpacing1, line, &n, 1, false);
    mystrncpy (AirportIdentifier, line, &n, 4, false);
    mystrncpy (ICAOCode1, line, &n, 2, false);
    mystrncpy (SubsectionCode1, line, &n, 1, false);
    mystrncpy (SIDSTARApproachIdentifier, line, &n, 6, false);
    mystrncpy (RouteType, line, &n, 1, false);
    mystrncpy (TransitionIdentifier, line, &n, 5, false);
    mystrncpy (ProcedureDesignAircraftCategoryorType, line, &n, 1, false);
    mystrncpy (SequenceNumber, line, &n, 3, false);

    iSequenceNumber = atoi(SequenceNumber);
    mystrncpy (FixIdentifier, line, &n, 5, false);
    mystrncpy (ICAOCode2, line, &n, 2, false);
    mystrncpy (SectionCode2, line, &n, 1, false);
    mystrncpy (SubsectionCode2, line, &n, 1, false);
    mystrncpy (ContinuationRecordNo, line, &n, 1, false);
    mystrncpy (WaypointDescriptionCode, line, &n, 4, false);
    mystrncpy (TurnDirection, line, &n, 1, false);
    mystrncpy (RNP1, line, &n, 3, false);
    mystrncpy (PathandTermination, line, &n, 2, false);
    mystrncpy (TurnDirectionValid, line, &n, 1, false);
    mystrncpy (RecommendedNavaid, line, &n, 4, false);
    mystrncpy (ICAOCode3, line, &n, 2, false);
    mystrncpy (ARCRadius, line, &n, 6, false);
    mystrncpy (Theta, line, &n, 4, false);
    mystrncpy (Rho, line, &n, 4, false);
    mystrncpy (MagneticCourse, line, &n, 4, false);
    mystrncpy (RouteDistanceHoldingDistanceorTime, line, &n, 4, false);
    mystrncpy (RECDNAVSection, line, &n, 1, false);
    mystrncpy (RECDNAVSubsection, line, &n, 1, false);
    mystrncpy (InboundOutbound, line, &n, 1, false);
    mystrncpy (Reservedexpansion1, line, &n, 1, false);
    mystrncpy (AltitudeDescription, line, &n, 1, false);
    mystrncpy (ATCIndicator, line, &n, 1, false);
    mystrncpy (Altitude1, line, &n, 5, false);
    mystrncpy (Altitude2, line, &n, 5, false);
    mystrncpy (TransitionAltitude, line, &n, 5, false);
    mystrncpy (SpeedLimit, line, &n, 3, false);
    mystrncpy (VerticalAngle, line, &n, 4, false);
    mystrncpy (CenterFix, line, &n, 5, false);
    mystrncpy (MultipleCode, line, &n, 1, false);
    mystrncpy (ICAOCode4, line, &n, 2, false);
    mystrncpy (SectionCode3, line, &n, 1, false);
    mystrncpy (SubsectionCode3, line, &n, 1, false);
    mystrncpy (GPSFMSIndication, line, &n, 1, false);
    mystrncpy (BlankSpacing2, line, &n, 1, false);

    mystrncpy (ApchRouteQualifier1a, line, &n, 1, false);
    mystrncpy (ApchRouteQualifier2a, line, &n, 1, false);
    mystrncpy (BlankSpacing3, line, &n, 3, false);
    mystrncpy (FileRecordNumber1, line, &n, 5, false);
    mystrncpy (CycleDate, line, &n, 4, false);
    iCycleDate = atoi (CycleDate);
  }

  int ApproachRecordDataContinuation (char *line){
    int n=0;
    mystrncpy (FieldasonPrimaryRecords, line, &n, 39, false);
    mystrncpy (APPLTYPE, line, &n, 1, false);  // This is where it is determined what type of data follows?  See page 182  E is primary records extension
    mystrncpy (FASBLOCK, line, &n, 1, false);
    mystrncpy (FASBLOCKServiceName, line, &n, 10, false);
    mystrncpy (LNAVVNAV, line, &n, 1, false);
    mystrncpy (LNAVVNAVServiceName, line, &n, 10, false);
    mystrncpy (LNAVforSBAS, line, &n, 1, false);
    mystrncpy (LNAVServiceName, line, &n, 10, false);
    mystrncpy (BlankSpacing9, line, &n, 15, false);
    mystrncpy (RNPAUTH1, line, &n, 1, false);
    mystrncpy (RNPSERV1, line, &n, 3, false);
    mystrncpy (RNPAUTH2, line, &n, 1, false);
    mystrncpy (RNPSERV2, line, &n, 3, false);
    mystrncpy (RNPAUTH3, line, &n, 1, false);
    mystrncpy (RNPSERV3, line, &n, 3, false);
    mystrncpy (RNPAUTH4, line, &n, 1, false);
    mystrncpy (RNPSERV4, line, &n, 3, false);
    mystrncpy (BlankSpacing9, line, &n, 14, false);
    mystrncpy (APPRTETypeQ1, line, &n, 1, false);
    mystrncpy (APPRTETypeQ2, line, &n, 1, false);
    mystrncpy (BlankSpacing9, line, &n, 3, false);
    mystrncpy (FileRecordNumber3, line, &n, 5, false);
    mystrncpy (CycleDate, line, &n, 4, false);
  }    

  // OBSOLETE // int ApproachRecordContinuation (char *line){
  // OBSOLETE //   int n=0;
  // OBSOLETE //   mystrncpy (FieldasonPrimaryRecords, line, &n, 38, false);
  // OBSOLETE //   // Now unique
  // OBSOLETE //   mystrncpy (ContinuationRecordNo, line, &n, 1, false);
  // OBSOLETE //   mystrncpy (ReservedSpacing, line, &n, 1, false);
  // OBSOLETE //   mystrncpy (ReservedSpacing, line, &n, 1, false);
  // OBSOLETE //   mystrncpy (CATADecisionHeight, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (CATBDecisionHeight, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (CATCDecisionHeight, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (CATDDecisionHeight, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (CATAMinimumDescentAltitude, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (CATBMinimumDescentAltitude, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (CATCMinimumDescentAltitude, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (CATDMinimumDescentAltitude, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (BlankSpacing5, line, &n, 13, false);
  // OBSOLETE //   mystrncpy (ProcedureCategory, line, &n, 4, false);
  // OBSOLETE //   mystrncpy (RNP2, line, &n, 3, false);
  // OBSOLETE //   mystrncpy (Reservedexpansion2, line, &n, 26, false);
  // OBSOLETE //   mystrncpy (ApchRouteQualifier1b, line, &n, 1, false);
  // OBSOLETE //   mystrncpy (ApchRouteQualifier2b, line, &n, 1, false);
  // OBSOLETE //   mystrncpy (BlankSpacing5, line, &n, 3, false);
  // OBSOLETE //   mystrncpy (FileRecordNumber2, line, &n, 5, false);
  // OBSOLETE //   mystrncpy (CycleDate, line, &n, 4, false);
  // OBSOLETE // }    


  void transition_identifier(){
    // Table 5-14 TransitionIdentifier
    // Engine Out SID       | 0 | Runway (RWY) or Pad Identifier
    // SID/RNAV SID         | 1 | Runway (RWY) or Pad Identifier
    //                      | 2 | Blank/RWY/PAD/ALL (Note 1 and 3)
    //                      | 3 | SID Enroute Transition Identifier (Note 5)
    // Vector SID           | T | Runway (RWY) or Pad Identifier
    //                      | V | Vector SID Enroute Transition Identifier
    // STAR/ RNAV STAR      | 1 | STAR Enroute Transition Identifier (Note 5)
    //                      | 2 | Blank RWY/PAD/ALL/ (Note 3)
    //                      | 3 | Runway (RWY) or Pad Identifier (Note 2)
    // Approach Transitions | A | Approach Transition Identifier
    // Missed Approach      | Z | Missed Approach Transition Identifier (Note 4)
    // Approach Procedure   | All Other Codes Except A and Z (see Section 5.7) | Blank
    if (!strncmp(TransitionIdentifier, "0", 1)){
      verbose (("-Runway (RWY) or Pad Identifier"));
    }else if (!strncmp(TransitionIdentifier, "1", 1)){
      verbose (("-Runway (RWY) or Pad Identifier"));
    }else if (!strncmp(TransitionIdentifier, "2", 1)){
      verbose (("-Blank/RWY/PAD/ALL (Note 1 and 3)"));
    }else if (!strncmp(TransitionIdentifier, "3", 1)){
      verbose (("-SID Enroute Transition Identifier (Note 5)"));
    }else if (!strncmp(TransitionIdentifier, "T", 1)){
      verbose (("-Runway (RWY) or Pad Identifier"));
    }else if (!strncmp(TransitionIdentifier, "V", 1)){
      verbose (("-Vector SID Enroute Transition Identifier"));
    }else if (!strncmp(TransitionIdentifier, "1", 1)){
      verbose (("-STAR Enroute Transition Identifier (Note 5)"));
    }else if (!strncmp(TransitionIdentifier, "2", 1)){
      verbose (("-Blank RWY/PAD/ALL/ (Note 3)"));
    }else if (!strncmp(TransitionIdentifier, "3", 1)){
      verbose (("-Runway (RWY) or Pad Identifier (Note 2)"));
    }else if (!strncmp(TransitionIdentifier, "A", 1)){
      verbose (("-Approach Transition Identifier"));
    }else if (!strncmp(TransitionIdentifier, "Z", 1)){
      verbose (("-Missed Approach Transition Identifier"));
    }else if (!strncmp(TransitionIdentifier, " ", 1)){
      verbose (("-All Other Codes"));// Except A and Z (see Section 5.7),");
    }else{
      verbose (("-Alternate Transition Identifier"));
    }
    // delete [] pointer;
  }

  int waypoint_description_code(){
    int retval = 0;
    // Waypoint Description Used On Column Column Column Column Remarks
    // Type/ Function/ Attribute  Enroute, SID, STAR, APCH 40 41 42 43
    // Airport as Waypoint  STAR, APCH A 
    // Essential Waypoint  Enroute, SID, STAR, APCH E Note 1
    // Off Airway Floating Waypoint Enroute F Note 1  
    // Runway as Waypoint, Helipad as Waypoint  SID, STAR, APCH G
    // Heliport as Waypoint  STAR, APCH H
    // NDB Navaid as Waypoint  Enroute, SID, STAR, APCH N 
    // Phantom Waypoint  SID, STAR, APCH P Note 1
    // Non-Essential Waypoint Enroute R Note 1
    // Transition Essential Waypoint Enroute T Note 1
    // VHF Navaid As Waypoint  Enroute, SID, STAR, APCH V  
    // Flyover Waypoint, Ending Leg  SID, STAR, APCH B Note 2
    // End of Continuous Segment  Enroute, SID, STAR, APCH E Note 2
    // Uncharted Airway Intersection Enroute U Note 1
    // Fly-Over Waypoint  APCH, SID, STAR, Y Note 2
    // Unnamed Stepdown Fix Final Approach Segment APCH A
    // Unnamed Stepdown Fix Intermediate Approach Segment APCH B
    // ATC Compulsory Reporting Point  SID, STAR, APCH Enroute C Note 1
    // Oceanic Gateway Waypoint Enroute G Note 1
    // First Leg of Missed Approach Procedure APCH M Note 3
    // Fix used for turning final approach APCH R Note 4
    // Named Stepdown Fix APCH S 
    // Initial Approach Fix APCH A Note 1
    // Intermediate Approach Fix APCH B Note 1
    // Holding at Initial Approach Fix APCH C
    // Initial Approach Fix at FACF APCH D
    // Final End Point APCH E Note 1
    // Final Approach Fix APCH F Note 1
    // Source provided Enroute Waypoint without Holding Enroute G
    // Source provided Enroute Waypoint with Holding		       Enroute SID, STAR, APCH H
    // Final Approach Course Fix APCH I Note 1
    // Missed Approach Point APCH M Note 1
    // Engine Out SID Missed Approach Disarm Point  SID (Engine Out), APCH N Note 5

    switch (*(WaypointDescriptionCode+0))
      {
      case 'A' :
	vstrappend (WaypointDescriptionCode, "-A-Airport as Waypoint:");
	break;
      case 'E' :
	vstrappend (WaypointDescriptionCode, "-E-Essential Waypoint:");
	break;
      case 'F' :
	vstrappend (WaypointDescriptionCode, "-F-Off Airway Floating Waypoint:");
	break;
      case 'G' :
	vstrappend (WaypointDescriptionCode, "-G-Runway as Waypoint or Helipad as Waypoint:");
	break;
      case 'H' :
	vstrappend (WaypointDescriptionCode, "-H-Heliport as Waypoint:");
	break;
      case 'N' :
	vstrappend (WaypointDescriptionCode, "-N-NDB Navaid as Waypoint:");
	break;
      case 'P' :
	vstrappend (WaypointDescriptionCode, "-P-Phantom Waypoint:");
	break;
      case 'R' :
	vstrappend (WaypointDescriptionCode, "-R-Non-Essential Waypoint:");
	break;
      case 'T' :
	vstrappend (WaypointDescriptionCode, "-T-Transition Essential Waypoint:");
	break;
      case 'V' :
	vstrappend (WaypointDescriptionCode, "-V-VHF Navaid As Waypoint:");
	break;
      }
  
    switch (*(WaypointDescriptionCode+1))
      {
      case 'B' :
	vstrappend (WaypointDescriptionCode, "-B-Flyover Waypoint, Ending Leg:");
	break;
      case 'E' :
	vstrappend (WaypointDescriptionCode, "-E-End of Continuous Segment:");
	break;
      case 'U' :
	vstrappend (WaypointDescriptionCode, "-U-Uncharted Airway Intersection:");
	break;
      case 'Y' :
	vstrappend (WaypointDescriptionCode, "-Y-Fly-Over Waypoint:");
	break;
      }

    switch (*(WaypointDescriptionCode+2))
      {
      case 'A' :
	vstrappend (WaypointDescriptionCode, "-A-Unnamed Stepdown Fix Final Approach Segment:");
	break;
      case 'B' :
	vstrappend (WaypointDescriptionCode, "-B-Unnamed Stepdown Fix Intermediate Approach Segment:");
	break;
      case 'C' :
	vstrappend (WaypointDescriptionCode, "-C-ATC Compulsory Reporting Point:");
	break;
      case 'G' :
	vstrappend (WaypointDescriptionCode, "-G-Oceanic Gateway Waypoint:");
	break;
      case 'M' :
	vstrappend (WaypointDescriptionCode, "-M-First Leg of Missed Approach Procedure:");
	retval = 1;
	break;
      case 'R' :
	vstrappend (WaypointDescriptionCode, "-R-Fix used for turning final approach:");
	break;
      case 'S' :
	vstrappend (WaypointDescriptionCode, "-S-Named Stepdown Fix:");
	break;
      }

    switch (*(WaypointDescriptionCode+3))
      {
      case 'A' :
	vstrappend (WaypointDescriptionCode, "-A-Initial Approach Fix:");
	break;
      case 'B' :
	vstrappend (WaypointDescriptionCode, "-B-Intermediate Approach Fix:");
	break;
      case 'C' :
	vstrappend (WaypointDescriptionCode, "-C-Holding at Initial Approach Fix:");
	break;
      case 'D' :
	vstrappend (WaypointDescriptionCode, "-D-Initial Approach Fix at FACF:");
	break;
      case 'E' :
	vstrappend (WaypointDescriptionCode, "-E-Final End Point:");
	break;
      case 'F' :
	vstrappend (WaypointDescriptionCode, "-F-Final Approach Fix:");
	break;
      case 'G' :
	vstrappend (WaypointDescriptionCode, "-G-Source provided Enroute Waypoint without Holding:");
	break;
      case 'H' :
	vstrappend (WaypointDescriptionCode, "-H-Source provided Enroute Waypoint with Holding:");
	break;
      case 'I' :
	vstrappend (WaypointDescriptionCode, "-I-Final Approach Course Fix:");
	break;
      case 'M' :
	vstrappend (WaypointDescriptionCode, "-M-Missed Approach Point:");
	break;
      case 'N' :
	vstrappend (WaypointDescriptionCode, "-N-Engine Out SID Missed Approach Disarm Point:");
	break;
      }
    printf (",");
    return retval;
  }

  int route_type(){
    // Table 5-7 – Airport Approach (PF) and Heliport Approach(HF) Records
    // A "Approach Transition"
    // B "Localizer/Backcourse Approach"
    // D "VORDME Approach"
    // F "Flight Management System (FMS) Approach"
    // G "Instrument Guidance System (IGS) Approach"
    // H "Area Navigation (RNAV) Approach with Required Navigation Performance (RNP) Approach"
    // I "Instrument Landing System (ILS) Approach"
    // J "GNSS Landing System (GLS)Approach"
    // L "Localizer Only (LOC) Approach"
    // M "Microwave Landing System (MLS) Approach"
    // N "Non-Directional Beacon (NDB) Approach"
    // P "Global Positioning System (GPS) Approach"
    // Q "Non-Directional Beacon + DME (NDB+DME) Approach"
    // R "Area Navigation (RNAV) Approach (Note 1)"
    // S "VOR Approach using VORDME/VORTAC"
    // T "TACAN Approach"
    // U "Simplified Directional Facility (SDF) Approach"
    // V "VOR Approach"
    // W "Microwave Landing System (MLS), Type A Approach"
    // X "Localizer Directional Aid (LDA) Approach"
    // Y "Microwave Landing System (MLS), Type B and C Approach"
    // Z "Missed Approach"
    int out = 0;
    if (!strncmp(RouteType, "A", 1) || !strncmp(RouteType, "Trans", 5)){
      out = 1;
      strcpy (RouteType, "Trans");
      vstrappend (RouteType, "-Approach Transition");
    }else if (!strncmp(RouteType, "B", 1) || !strncmp(RouteType, "LOC/BC", 6)){
      out = 2;
      strcpy (RouteType, "LOC/BC");
      vstrappend (RouteType, "-Localizer/Backcourse Approach");
    }else if (!strncmp(RouteType, "D", 1 || !strncmp(RouteType, "VOR/DME", 7))){
      out = 2;
      strcpy (RouteType, "VOR/DME");
      vstrappend (RouteType, "-VORDME Approach");
    }else if (!strncmp(RouteType, "F", 1) || !strncmp(RouteType, "FMS", 3)){
      out = 2;
      strcpy (RouteType, "FMS");
      vstrappend (RouteType, "-Flight Management System (FMS) Approach");
    }else if (!strncmp(RouteType, "G", 1) || !strncmp(RouteType, "IGS", 3)){
      out = 2;
      strcpy (RouteType, "IGS");
      vstrappend (RouteType, "-Instrument Guidance System (IGS) Approach");
    }else if (!strncmp(RouteType, "H", 1) || !strncmp(RouteType, "RNAV-RNP", 8)){
      out = 2;
      strcpy (RouteType, "RNAV-RNP");
      vstrappend (RouteType, "-Area Navigation (RNAV) Approach with Required Navigation Performance (RNP) Approach");
    }else if (!strncmp(RouteType, "I", 1) || !strncmp(RouteType, "ILS", 3)){
      out = 2;
      strcpy (RouteType, "ILS");
      vstrappend (RouteType, "-Instrument Landing System (ILS) Approach");
    }else if (!strncmp(RouteType, "J", 1) || !strncmp(RouteType, "GLS", 3)){
      out = 2;
      strcpy (RouteType, "GLS");
      vstrappend (RouteType, "-GNSS Landing System (GLS)Approach");
    }else if (!strncmp(RouteType, "L", 1) || !strncmp(RouteType, "LOC", 3)){
      out = 2;
      strcpy (RouteType, "LOC");
      vstrappend (RouteType, "-Localizer Only (LOC) Approach");
    }else if (!strncmp(RouteType, "M", 1) || !strncmp(RouteType, "MLS", 3)){
      out = 2;
      strcpy (RouteType, "MLS");
      vstrappend (RouteType, "-Microwave Landing System (MLS) Approach");
    }else if (!strncmp(RouteType, "N", 1) || !strncmp(RouteType, "NDB", 3)){
      out = 2;
      strcpy (RouteType, "NDB");
      vstrappend (RouteType, "-Non-Directional Beacon (NDB) Approach");
    }else if (!strncmp(RouteType, "P", 1) || !strncmp(RouteType, "GPS", 3)){
      out = 2;
      strcpy (RouteType, "GPS");
      vstrappend (RouteType, "-Global Positioning System (GPS) Approach");
    }else if (!strncmp(RouteType, "Q", 1) || !strncmp(RouteType, "NDB+DME", 7)){
      out = 2;
      strcpy (RouteType, "NDB+DME");
      vstrappend (RouteType, "-Non-Directional Beacon + DME (NDB+DME) Approach");
    }else if (!strncmp(RouteType, "R", 1) || !strncmp(RouteType, "RNAV", 4)){
      out = 2;
      strcpy (RouteType, "RNAV");
      vstrappend (RouteType, "-Area Navigation (RNAV) Approach");
    }else if (!strncmp(RouteType, "S", 1) || !strncmp(RouteType, "VOR/DME", 7)){
      out = 2;
      strcpy (RouteType, "VOR/DME");
      vstrappend (RouteType, "-VOR Approach using VORDME/VORTAC");
    }else if (!strncmp(RouteType, "T", 1) || !strncmp(RouteType, "TACAN", 5)){
      out = 2;
      strcpy (RouteType, "TACAN");
      vstrappend (RouteType, "-TACAN Approach");
    }else if (!strncmp(RouteType, "U", 1) || !strncmp(RouteType, "SDF", 3)){
      out = 2;
      strcpy (RouteType, "SDF");
      vstrappend (RouteType, "-Simplified Directional Facility (SDF) Approach");
    }else if (!strncmp(RouteType, "V", 1) || !strncmp(RouteType, "VOR", 3)){
      out = 2;
      strcpy (RouteType, "VOR");
      vstrappend (RouteType, "-VOR Approach");
    }else if (!strncmp(RouteType, "W", 1) || !strncmp(RouteType, "MLS-A", 5)){
      out = 2;
      strcpy (RouteType, "MLS-A");
      vstrappend (RouteType, "-Microwave Landing System (MLS), Type A Approach");
    }else if (!strncmp(RouteType, "X", 1) || !strncmp(RouteType, "LDA", 3)){
      out = 2;
      strcpy (RouteType, "LDA");
      vstrappend (RouteType, "-Localizer Directional Aid (LDA) Approach");
    }else if (!strncmp(RouteType, "Y", 1) || !strncmp(RouteType, "MLS-B/C", 7)){
      out = 2;
      strcpy (RouteType, "MLS-B/C");
      vstrappend (RouteType, "-Microwave Landing System (MLS), Type B and C Approach");
    }else if (!strncmp(RouteType, "Z", 1) || !strncmp(RouteType, "Missed", 6)){
      out = 3;
      strcpy (RouteType, "Missed");
      vstrappend (RouteType, "-Missed Approach");
    }else{
      vstrappend (RouteType, "-Unidentified approach route type");
    }
    return out;
  }
  
};

