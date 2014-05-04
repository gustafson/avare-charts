#!/usr/bin/perl
#This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Copywrite 2012 Mike Stewart http://www.mstewart.net


#DownloadPlates.pl script to get PDF plates from the FAA for use with GRT EFIS
#This tool superceeded the grtgetallplates.pl script. Delete everything you have 
#relative to this older tool. Delete EVERYTHING including your plates. I no longer use the NACOMATIC
#tool. 
# make sure to put a copy of wget somewhere in the path. See instructions.txt
# make sure you have run from a command prompt ppm install xml-xpath

my $fileVer   = "v4.1"; #this script version
use XML::XPath;
use XML::XPath::XMLParser;
#use strict;
use Time::Local;
use Getopt::Long;
use Socket;
use FindBin qw($Bin);
#use warnings;

 
my $ip_address;
my $nacoaddr = "aeronav.faa.gov";
my $xmlDataDir = "xml_data";
#obtain the NACO ip address
my $packed_ip = gethostbyname($nacoaddr);
if (defined $packed_ip)
	{
		$ip_address = inet_ntoa($packed_ip);
        	print "$nacoaddr found at $ip_address\n";
	}
else
	{
		die "unable to get the NACO IP address from $nacoaddr $!"
	}

my $webServer = "http://$ip_address/d-tpp/";
my $tppIndex  = "http://$ip_address/index.asp?xml=aeronav/applications/d_tpp";
my $tppIndex  = "http://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/dtpp";
my $xmlFile   = "d-TPP_Metafile.xml";	
my $outputDir = "plates";
# Define wgetCmd here as null for global scoping, we'll set it below based on the Operating System
my $wgetCmd   = "";
#my $wgetCmd   = "wget --tries=8 -T 30 --progress=bar:force -nv -O ";
#my $wgetCmd   = "wget --tries=8 --progress=bar:force -nv -O ";

my $MySlash   = "\\";#thanks Matt
my $MyDash = "-";
my $indexFile = "d-tpp-index.html";#NACO index file to parse to get current cycle
my $filesize;

# setup my defaults
my $debug;
my $states;
my $volumes;
my $getmins="no";
my $help = 0;
my $destination;
my $forceupdate="no";
#my $startover="no";
my $longName="";
my $statefolders=""; # for the option
my $statefolder = ""; # for writing path
my $cityNameDir = ""; # for writing path


my $os = $^O;#return the OS name to work cross platform
print "Running in: $os\n";
#sent to me by John Ewing to get his Mac OS X 10.5.7 working 
if ($os =~ "darwin")
	{
	$wgetCmd   = "curl --retry 8 --progress -v -o "; # For Mac OS X
	} 
else 
	{
	$wgetCmd   = "wget --tries=8 --progress=bar:force -nv -O "; # For Windows, et al.
	}


if ($os =~ "MSWin32")
	{
	$MySlash="\\";	# For Windows
	}
else
	{
	$MySlash="/";	# For other OS'
	}

GetOptions(
    'debug=s'    	=> \$debug,
    'states=s'     	=> \$states,
    'volumes=s' 	=> \$volumes,
    'help!'     	=> \$help,
    'destination=s' 	=> \$destination,
    'forceupdate=s' 	=> \$forceupdate,
    'getmins=s'		=> \$getmins,
    'longfilenames=s'	=> \$longName,
    'statefolders=s'	=> \$statefolders
    )
        or die "Incorrect usage! Please read the instructions.txt\n";
if( $help ) 
	{
    	print "Please see the instructions.txt file for usage\n";
    	system ("instructions.txt");
    	exit ();
	} 
if ((!defined($states)) && (!defined($volumes)))
	{
		$states = "all";
		#print "states set to =$states due to undefined\n";
	}
if (defined($destination))
	{
		if (! -e $destination)
			{
				print "destination:$destination\n";
				mkdir($destination) || die "unable to make destination directory $destination  $!";
				print MyLogFile "created $destination\n";
			}
		$outputDir = "$destination$MySlash$outputDir$MySlash";
		print "$outputDir\n";
	}
else
	{
		$destination=$Bin;
		$outputDir = "$destination$MySlash$outputDir$MySlash";
		print "output dir: $outputDir\n";
	}
#print "$destination\n";
#print "$outputDir\n";
#exit ();
################################################################################
#   Main
################################################################################
#lets get timers and log file going.
print "\n\n DownloadPlates.pl $fileVer firing up. Here we go!\n";
my $iStartTime = (time);
open(MyLogFile,  ">>logfile.txt") || die "Opening logfile.txt: $!";
print "Beginning Script " . localtime(time) . "\n";
print MyLogFile "\n\ndownloadplates.pl $fileVer firing up. Here we go!\n";
print MyLogFile "Beginning Script " . localtime(time) . "\n";
print MyLogFile "Script Version $fileVer\n";
print MyLogFile "$nacoaddr found at $ip_address\n";
print MyLogFile "OS Type  $os\n";
print MyLogFile "debug = $debug\n";
print MyLogFile "states = $states\n";
print MyLogFile "volumes = $volumes\n";
print MyLogFile "destination= $destination\n";
print MyLogFile "Forceupdate = $forceupdate\n";
print MyLogFile "Getmins = $getmins\n";
#print MyLogFile "Startover = $startover\n";


##############
#OK Now lets get the plate XML calatog from the FAA NACO site
my $htmlcycle = GetCycleHTML();	           
my $htmlcycle = "1405";
print "HTML cycle = $htmlcycle\n";

#exit ();

#with the FAA hosing me on this XML catalog file, temp fix is to manually support it on my servers. ARGH!

### USE THIS TO GET NEW LIST 
## my $cmd = "$wgetCmd $xmlFile $webServer$htmlcycle$MySlash$xmlDataDir$MySlash$xmlFile";
## print $cmd
# ZK my $cmd = "$wgetCmd $xmlFile $webServer/1303$MySlash$xmlDataDir$MySlash$xmlFile";
## my $cmd = "$wgetCmd $xmlFile http://mstewart.net/super8/grtgetallplates/d-TPP_Metafile.xml";

### USE THIS TO NOT REDOWNLOAD
my $cmd = "dir"; #I use this for testing only so I donthave to keep downloading the xml
#print "downloading from the FAA's NACO site $xmlFile for the cycle $htmlcycle\n";
print "$cmd\n";
#print "downloading from mstewart.net the lastest $xmlFile he has. \n";
#print "Please stand by.......\n";
print MyLogFile "$cmd\n" if $debug=~"yes";
print MyLogFile "downloading $xmlFile for the cycle $htmlcycle\n";
if (-e $xmlFile) {
}
else {
system ($cmd) && die "unable to get $xmlFile: $!";
	die "Can't find file \"$xmlFile\"" 	  
		unless -f $xmlFile;
}

if (! -e $outputDir)
{
	mkdir($outputDir) || die "unable to make directory plates:  $!";
}
#time to load the XML for the actual work effort	
	print "loading XML file. This could take a few minutes.\n";
	print "Please stand by........\n";
    	my $xmlRef = XML::XPath->new(filename => $xmlFile);
    
	# parse the xml doc
	my $tppSet		= $xmlRef->find('//digital_tpp') || die "couldn't find digital_tpp node:  $!";
	#CheckXML ($tppSet);
	my $iAirports	= 0;
	my $iCharts		= 0;
	my $iChanged	= 0;
	my $iDeleted    = 0;
	my $iDownloaded	= 0;
	my $iMinCharts  = 0;
	my $iAddedCharts= 0;
	my $iChanged	= 0;
	my $iAirportDirCreated =0;
	
	foreach my $tpp ($tppSet->get_nodelist)# here come the parsing of the XML part
    	{
		my $xmlcycle		= $tpp->find('@cycle');
		print "html cycle=$htmlcycle and xml cycle=$xmlcycle\n";
		if ( $htmlcycle =~ $xmlcycle)# just in case there is some problem with the cycles
		{
			#print "do nothing\n";
			} 
		else
		{
			#print MyLogFile "html cycle:$htmlcycle does not equal xml cycle:$xmlcycle  . Terminating script.\n";
			#print "html cycle:$htmlcycle does not equal xml cycle:$xmlcycle  . Terminating script.\n";
			print MyLogFile "html cycle:$htmlcycle does not equal xml cycle:$xmlcycle  . The XML CATALOG IS OUT OF DATE!!!!\n";
			print MyLogFile "Im getting the files from cycle $htmlcycle but with an out of date catalog, im surely missing a few plates and changes. The files I got are current\n";
			print "html cycle:$htmlcycle does not equal xml cycle:$xmlcycle  . The XML CATALOG IS OUT OF DATE!!!!\n";
			print "Im getting the files from cycle $htmlcycle but they are NOT CURRENT!\n";
			$xmlcycle = $htmlcycle;#just force it to get the current cycle with an out of date catalog and hope for the best.
			print "xmlcycle now is $xmlcycle\n";
			#exit ();
		}			
		my $fromDate	= $tpp->find('@from_edate');
		my $toDate		= $tpp->find('@to_edate');
		print "NACO XML cycle:  $xmlcycle\n";
		print "from:   $fromDate\n";
		print "to:     $toDate\n";
		print MyLogFile "NACO XML cycle:  $xmlcycle\n";
		print MyLogFile "from:   $fromDate\n";
		print MyLogFile "to:     $toDate\n";
		print MyLogFile "NACO XML file cycle:  $xmlcycle\n";
		#exit ();
		my $stateList = $tpp->find('state_code');
		foreach my $state ($stateList->get_nodelist)
		{
			my $stateName = $state->find('@state_fullname')->string_value;
			my $stateID = $state->find('@ID')->string_value;
			if ($statefolders=~"yes")
			{
				$statefolder = ($stateName . $MySlash);
								
			}
			else
			{
				$statefolder = ("");
			}	
			print MyLogFile "stateName:$stateName state ID:$stateID\n" if $debug=~"yes";
			my $cityList = $state->find('city_name');
			foreach my $city ($cityList->get_nodelist)
			{
				my $cityName = $city->find('@ID')->string_value;
				#$cityName =~ s/[ |\/|\\]/-/g;# convert spaces and slashes to dash
				$cityName =~ s/[ |\/|\\|\.]/-/g;# convert spaces, ., and slashes to dash 
				if ($statefolders=~"yes")
				{
					#$statefolder = ($statefolder . $cityName .$MySlash);
					$cityNameDir = ($cityName . $MySlash);			
				}
				else
				{
					$cityNameDir = ("");
				} 
				my $volumeID = $city->find('@volume')->string_value;
				#print "volumeID = $volumeID\n";
				#if (($states =~ m/$stateID/i) || ($getall=~"yes") || ($volumes =~m/$volumeID/i))
				my $airportList = $city->find('airport_name');
				foreach my $airport ($airportList->get_nodelist)
				{
					$iAirports++;
					my $airportID = $airport->find('@apt_ident')->string_value;
					my $icaoID    = $airport->find('@icao_ident')->string_value;
					print "airport:  $airportID, $icaoID\n" if $debug=~"yes";
					my $recordList = $airport->find('record');
					foreach my $record ($recordList->get_nodelist)
					{
						print MyLogFile "states: $states stateID:$stateID stateName:$stateID cityName:$cityName airportID:$airportID\n" if $debug=~"yes";
						$iCharts++;
						my $chartCode = $record->find('chart_code');
						my $chartName = $record->find('chart_name');
						$chartName =~ s/[ |\/|\\]/-/g;	# convert spaces and slashes to dash
						$chartName =~ s/[(|)]//g;		# remove parens
						if ($longName)
						{
							$chartName=($stateID . $MyDash . $airportID . $MyDash .  $chartName);
							print "chartname:$chartName\n" if $debug=~"yes";
							
						}	
						my $pdfName   = $record->find('pdf_name');
						my $useraction= $record->find('useraction');
						# skip the takeoff minimum charts
						if (($chartCode =~ /^MIN$/) && ($getmins=~"no"))
						{
							$iMinCharts++;
							print MyLogFile "stateID:$stateID stateName:$stateName cityName:$cityName airportID: $airportID chartName:$chartName skipped due to mins \n" if $debug=~"yes";
							print "skipping min chart: $stateName $airportID  $chartName\n";
						}
						else
						{
							if ($useraction =~ /D/)
							{
								$iDeleted++;
								print MyLogFile "would have deleted $airportID, $chartName, $pdfName, changed:$useraction \n" if $debug=~"yes";
								if (-e ($outputDir . $statefolder . $cityNameDir . $airportID . $MySlash . $chartName . ".pdf"))
								{
									unlink($outputDir . $statefolder. $cityNameDir . $airportID . $MySlash . $chartName . ".pdf") || warn "unable to delete old chart file:$outputDir$MySlash$airportID$MySlash$chartName.pdf  $!";
									print "$chartName existed and it was deleted based on the FAA catalog forcedupdate:$forceupdate\n";
									print MyLogFile "$chartName existed and it was deleted based on the FAA catalog forcedupdate:$forceupdate\n" if $debug=~"yes";
									print MyLogFile "deleted $outputDir$MySlash$airportID$MySlash$chartName .pdf\n" if $debug=~"yes";
								}
								#else #should have been there
								#{
								#print "Catalog said $airportID  $chartName.pdf was to be deleted but it was not found.\n";
								#print MyLogFile "Catalog said $airportID  $chartName.pdf was to be deleted but it was not found.\n";
								#}
							}
							#print MyLogFile "stateID:$stateID states:$states \n";
							
							elsif (($states =~ m/$stateID/i) || ($volumes =~m/$volumeID/i) || ($states =~ "all"))
							{
								print MyLogFile "would have downloaded $airportID, $chartName, $pdfName, changed:$useraction \n" if $debug=~"yes";
								my $outputFile = $outputDir . $statefolder . $cityNameDir .$airportID . $MySlash . $chartName . ".pdf";
								if (($useraction =~ /[A|C]/ ) || ($forceupdate =~ "yes") || (! -e ($outputFile)) ) 
								{
									if ($useraction =~ /C/)
									{
										$iChanged++;
									}
									if ($useraction =~ /A/)
									{
										$iAddedCharts++;
									}
									
									print "$airportID, $chartName, $pdfName, changed?  $useraction\n";
									print MyLogFile "would have downloaded $airportID, $chartName, $pdfName, changed:$useraction \n" if $debug=~"yes";
									if (! -e ($outputDir . $statefolder .  $airportID))
									{
										mkdir ($outputDir . $statefolder); 
										mkdir ($outputDir . $statefolder . $cityNameDir);
										mkdir ($outputDir . $statefolder . $cityNameDir . $airportID);
										print ("$outputDir$statefolder$airportID\n");
										$iAirportDirCreated++;
										#print MyLogFile "Airport dir created $outputDir$MySlash$airportID count:$iAirportDirCreated\n" if $debug=~"yes";
									}
									#$cmd = $wgetCmd . $MySlash . $outputFile . $MySlash . $webServer . $xmlcycle . $MySlash . $pdfName;
									$cmd = $wgetCmd . "\"" . $outputFile . "\" " . $webServer . $xmlcycle . "/" . $pdfName;
									if (!($debug=~"yes"))
									{
										#print MyLogFile "airport: $airportID Chartname: $chartName useraction:$useraction forceupdate:$forceupdate \n" if $debug=~"yes";
										system($cmd);
										$iDownloaded++;
										$filesize = ($filesize + (-s "$outputFile"));
									}
									else
									{
										print MyLogFile "command:$cmd\n";
										print "$cmd\n";
																				
									}
								}
							}
						}
					}
				}
			}
		}
	}		
my $iEndTime = (time);
my $RunTime = ($iEndTime-$iStartTime)/60;
$filesize = $filesize/1024/1024;#get to megabytes
print "\n\n";
print "airports processed:  		$iAirports\n";
print "charts available:    		$iCharts\n";
print "charts marked for changed:	$iChanged\n";
print "charts downloaded:   		$iDownloaded\n";
print "charts marked for delete:      	$iDeleted\n";
print "charts marked for add:      	$iAddedCharts\n";
print "Folders created for airports:	$iAirportDirCreated\n";
print "Mins charts skipped: 		$iMinCharts\n\n";
print "Your $iDownloaded charts were put in:		$outputDir\n";
print "You may view the logfile.txt file for additional information when this is done\n";
print "Runtime was $RunTime minutes\n";
print "I have a few things to clean up first. Your command prompt should show up shortly\n";
print "Please stand by...\n";

print MyLogFile "airports processed:  $iAirports\n";
print MyLogFile "charts available:    $iCharts\n";
print MyLogFile "charts marked for delete:      $iDeleted\n";
print MyLogFile "charts downloaded:   $iDownloaded\n";
print MyLogFile "charts marked for change:      $iChanged\n";
print MyLogFile "charts marked for add:      $iAddedCharts\n";
print MyLogFile "Directories created for airports: $iAirportDirCreated\n";
print MyLogFile "Amount downloaded: $filesize megabytes\n";
print MyLogFile "Mins charts skipped: $iMinCharts\n";
print MyLogFile "Your charts were put in:$outputDir\n";
print MyLogFile "Runtime was $RunTime minutes\n";
print MyLogFile "Script Complete " . localtime(time) . "\n\n\n";
close(myLogFile);
exit 0;

#routine to get the cycle number from the FAA website	
sub GetCycleHTML
{
	#was having issues with sget replacing the file. Have to delete.
	if (-e $indexFile)
	{
		unlink($indexFile);
		#print "$indexFile\n";
	}
	#my $cmd = $wgetCmd . " d-tpp-index.html " . $tppIndex;
	my $cmd = $wgetCmd . " $indexFile " . $tppIndex;
	print MyLogFile "$cmd\n" if $debug=~"yes";
	system($cmd);
	
	my $htmlcycle = "";
	
	open(INFILE, "d-tpp-index.html") || die "unable to open d-tpp-index.html:  $!";
	while (my $line = <INFILE>)
	{
		#print "$line\n";
		if ($line =~ /\"><a href=\"\/digital_tpp.asp\?ver=(\d{4})/ )
		{
			#print $line;
			$htmlcycle = $1;
		}
	}
	
	close(INFILE);
	#was having issues with sget replacing the file. Have to delete.
	if (-e $indexFile)
	{
		unlink($indexFile);
		print "$indexFile\n";
	}
	return $htmlcycle;
}
#not used yet
sub CheckXML
{
	my $FileToCheck=shift;
	print "$FileToCheck\n";
	exit ();
}
	
##################################################################
#
# This is old depricated stuff that I may have to use again some day
#
##################################################################                                   

	

