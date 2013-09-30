#!/usr/bin/perl


use strict;
use warnings;
use LWP::Simple;
use XML::Parser;
use CGI;

my $printraw = 0;
my $taf = "";
my $nomore = 0;
   
# The Handlers
sub hdl_start{
	my ($p, $elt, %atts) = @_;
	if($elt eq 'raw_text') {
		$printraw = 1;
	}
}
   
sub hdl_end {
	my ($p, $elt) = @_;
	if($elt eq 'raw_text') {
		$printraw = 0;
	}
}
  
sub hdl_char {
	my ($p, $str) = @_;

	if($nomore >= 1) {
		return;
	}
	if($printraw) {
		$taf = $str;
		$nomore++;
	}
}

sub hdl_def {
} 
 
my $parser = new XML::Parser (Handlers => {
                              Start   => \&hdl_start,
                              End     => \&hdl_end,
                              Char    => \&hdl_char,
                              Default => \&hdl_def,
                            });

# Process each TAF 

my $query = new CGI;
my $station = "K".$query->param("station");
my $response;

$response = get("http://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=tafs&requestType=retrieve&format=xml&stationString=$station&hoursBeforeNow=2") or $response = "$station not available";

$parser->parse($response);

if($nomore < 1) {
	$taf = "";
}

# remove ,
print "Content-type: text/html\n\n";
print <<HTML;
<html>
<body>
<p>$taf</p>
</body>
HTML

exit;

