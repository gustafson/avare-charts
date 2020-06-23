AIS subscriber files effective date 22 August 2013.

Dear Subscribers,

For the 22 August 2013 subscriber files, unless otherwise noted in the daily 
National Flight Data Digest (NFDD), the files incorporate data published in 
the NFDD through:

    NFDD 140 dated 7/22/2013



ADDITIONAL AIXM SUBSCRIBER FILES BEING PRODUCED 

AIXM 5.1 versions of the Navigation Aid, Airport, ASOS/AWOS, and Airway 
subscriber files are now produced. These products can be found with the FADDS 
"Additional Data".

The XML schema definition and FAA extensions are placed in a folder named 
AIXM\AIXM_5.1\AIXM

"Frequently asked questions" documents are placed in a folder named 
AIXM\AIXM_5.1\FAQs

Mappings of data attributes from the .txt file to the AIXM products 
are placed in a folder named AIXM\AIXM_5.1\mappings

The actual data files are zipped and placed in a folder named 
AIXM\AIXM_5.1\XML-Subscriber-Files 

NAVAID_AIXM
    The AIXM5.1 Navigation Aid subscriber file contains data also published 
    in both the NAV.txt and ILS.txt legacy subscriber files. Both the legacy 
    NAV.txt and ILS.txt products and the new AIXM product will be produced 
    concurrently.

APT_AIXM
    The AIXM5.1 Airport subscribe file contains the data also produced in the 
    legacy APT.txt subscriber file. Both products are produced in parallel.

AWOS_AIXM
    The AIXM5.1 ASOS/AWOS subscribe file contains the data also produced in 
    the legacy AWOS.txt subscriber file. Both products are produced in 
    parallel.

AWY_AIXM
    The AIXM5.1 AIRWAY subscribe file contains the data also produced in the 
    legacy AWY.txt subscriber file. Both products are produced in parallel.


SPECIAL ACTIVITY AIRSPACE (SAA) 
   
    The legacy SUA.txt file will no longer be produced. A new subscriber 
    product called Special Activity Airspace (SAA), containing SUA and Air 
    Traffic Control Assigned Airspace (ATCAA) data, has replaced it. The new 
    product is an XML product based on Aeronautical Information Exchange Model 
    version 5.0 (AIXM5). Information on AIXM can be found at 
    http://www.aixm.aero.

    The latest XML schema definition files for the new SAA subscriber product 
    can be found with the "Additional Data" this charting cycle.

    A mapping of data elements from the legacy SUA.txt to the new AIXM 
    product is provided with the "Additional Data". The file is named "SUA 
    Subscriber File -AIXM 5.0-mapping.xls". 
    
    The new AIXM SAA product can be found in the FADDS "Additional Data". The 
    subscriber data is zipped with the schema information, inside a zip file 
    named "SaaSubscriberFile.zip". All operational SUAs are included. There 
    are also 16 National Security Areas (NSA) that were not included in the 
    legacy SUA.txt file. ATCAA data has not yet been loaded. 

Other Notes:

UPDATE TO APT SUBSCRIBER FILE 17 OCTOBER 2013:

    The format of the APT.txt subscriber file will change slightly as of the 
    17 October 2013 charting cycle. The record length will increase 2 
    characters to accommodate an enlarged REMARK ELEMENT NAME in RMK 
    records. This change is to prevent possible truncation of information that 
    ties a remark to a specific data element reported elsewhere in the file. 
    The updated format specification is titled "apt_rf_Eff20131017.txt" and is 
    included with the FADDS "Additional Data".

DME ONLY NAVAIDS:

    In the future, we will be publishing information about navigation aids 
    comprised of only the DME component. We expect this information to start 
    appearing in late 2013. Updated subscriber format definitions for the 
    ANR, ATS, AWY, COM, FIX, HPF, LID, NATFIX, NAV, PFR, PJA, SSD, and STARDP 
    files can be found in the "Additional Data". We anticipate this will 
    start with the 12 December 2013 charting cycle. These files may contain or 
    reference NAVAIDs of type DME. The actual format of these data files will 
    not change, but the domain for NAVAID type has been expanded to include 
    "DME only".

ADVANCED NAVIGATION ROUTES:

    The ANR.txt file ("Advanced Navigation Routes") is a regular part of the 
    subscriber files. No ANR data, however, has been added to the database. 
    Therefore, the ANR.txt subscriber file contains no data. This is not an 
    error.

SHAPE FILES    

    Included in the "additional data files" are shape files describing Class 
    B, C, D, and E airspace.  Many geographic information system (GIS) 
    applications are capable of reading shape files (the dbf, shx, and shp 
    file extensions) included with each type of airspace.  The data for Class 
    B, C, and D has been verified. The data for Class E is considered Beta, 
    and is currently not for navigation. It is provided for analysis and 
    feedback. Please provide feedback to Aeronautical Information Services 
    (AIS) at 9-awa-ator-ais-feedback@faa.gov. 

REMINDER: 

The file formats for the current ".txt" subscriber files are included with the 
complete data download from the "FADDS - Facility Aeronautical Data 
Distribution System" website, or by requesting the "layout data" set.

The standard delivery mechanism for the subscriber files is the Facility 
Aeronautical Data Distribution System (FADDS). There are links to FADDS on 
the NFDC Portal located at http://nfdc.faa.gov. There is no cost to 
subscribe; users can select all or any of the files to download; you can 
register to receive email alerts when the new subscriber set becomes 
available. If there are changes to the contact information currently on file 
or you are unsure whether the information is correct, please e-mail your 
request to 9-awa-ator-ais-feedback@faa.gov. 

INSTRUCTIONS FOR REGISTERING TO THE FACILITY AERONAUTICAL DATA DISTRIBUTION 
SYSTEM (FADDS)

    Please point your browser to the NFDC Portal at https://nfdc.faa.gov 

    Follow the link to "My NFDC". 

    You must register as a 'New User' to request access to the site.

    The FADDS administrator will be notified and access/permissions will be 
    assigned.  

    When you receive your credentials and log in, you may use the "My Account" 
    feature to set up alerts.  You may download products from the FADDS page.

    Please contact AIS if you have difficulty logging into the site. 

A recent update to the NFDC Portal allows users to browse and download many 
products, including subscriber files, directly from the portal without logging 
in to FADDS. Alerts still require a FADDS account and login.

Your contact information, and comments or suggestions, can be 
directed to Aeronautical Information Services at the following 
contact points:

    Telephone:  202-385-7490. 
    email: 9-awa-ator-ais-feedback@faa.gov 
