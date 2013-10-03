#!/usr/bin/perl
#Copyright (c) 2012, Zubair Khan (governer@gmail.com)
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#



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

