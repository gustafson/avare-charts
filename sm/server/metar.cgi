#!/usr/bin/perl


use strict;
use warnings;
use LWP::Simple;
use CGI;

# get TFR list
my $query = new CGI;
my $station = "K".$query->param("station");
my $response;
$response = get("http://weather.noaa.gov/pub/data/observations/metar/stations/$station.TXT") or $response = "$station not available";

$response =~ s/.*\n//;
$response =~ s/\$//;

print "Content-type: text/html\n\n";
print <<HTML;
<html>
<body>
<p>$response</p>
</body>
HTML

