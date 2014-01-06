#!/usr/bin/perl
#Copyright (c) 2012, Apps4av Inc. (apps4av@gmail.com) 
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
use File::stat;
use Time::localtime;
binmode(STDOUT, ":utf8");
my $designator = "";
my $name = "";
my $upperlimit = "";
my $upperlimitref = "";
my $lowerlimit = "";
my $lowerlimitref = "";
my $beginposition = "";
my $endposition = "";
my $note = "";
my $lat = 0;
my $lon = 0;
my $numpos = 0;

my $p_airspace = 0;
my $p_designator = 0;
my $p_name = 0;
my $p_upperlimit = 0;
my $p_upperlimitref = 0;
my $p_lowerlimit = 0;
my $p_lowerlimitref = 0;
my $p_beginposition = 0;
my $p_endposition = 0;
my $p_pos = 0;
my $p_note = 0;

my $start = 0;

sub initnew {
    $designator = "";
    $name = "";
    $upperlimit = "";
    $upperlimitref = "";
    $lowerlimit = "";
    $lowerlimitref = "";
    $beginposition = "";
    $endposition = "";
    $lat = 0;
    $lon = 0;
    $numpos = 0;
    $note = "";

    $p_airspace = 0;
    $p_designator = 0;
    $p_name = 0;
    $p_upperlimit = 0;
    $p_upperlimitref = 0;
    $p_lowerlimit = 0;
    $p_lowerlimitref = 0;
    $p_beginposition = 0;
    $p_endposition = 0;
    $p_note = 0;
}


# The Handlers
sub hdl_start{
	my ($p, $elt, %atts) = @_;
	if($elt eq 'Airspace') {
        $p_airspace = 1;
	}
    if($p_airspace == 0) {
        return;
    }
	if($elt eq 'designator') {
        $p_designator = 1;
	}
    if($elt eq 'name') {
        $p_name = 1;
    }
    if($elt eq 'upperLimit') {
        $p_upperlimit = 1;
    }
    if($elt eq 'lowerLimit') {
        $p_lowerlimit = 1;
    }
    if($elt eq 'upperLimitReference') {
        $p_upperlimitref = 1;
    }
    if($elt eq 'lowerLimitReference') {
        $p_lowerlimitref = 1;
    }
    if($elt eq 'beginPosition') {
        $p_beginposition = 1;
    }
    if($elt eq 'endPosition') {
        $p_endposition = 1;
    }
    if($elt eq 'pos') {
        $p_pos = 1;
    }
    if($elt eq 'LinguisticNote') {
        $p_note = 1;
    }
}
   
sub hdl_end {
	my ($p, $elt) = @_;
    
	if($elt eq 'Airspace') {
        $p_airspace = 0;
	}
    if($p_airspace == 0) {
        return;
    }
	if($elt eq 'designator') {
        $p_designator = 0;
	}
    if($elt eq 'name') {
        $p_name = 0;
    }
    if($elt eq 'upperLimit') {
        $p_upperlimit = 0;
    }
    if($elt eq 'lowerLimit') {
        $p_lowerlimit = 0;
    }
    if($elt eq 'upperLimitReference') {
        $p_upperlimitref = 0;
    }
    if($elt eq 'lowerLimitReference') {
        $p_lowerlimitref = 0;
    }
    if($elt eq 'beginPosition') {
        $p_beginposition = 0;
    }
    if($elt eq 'endPosition') {
        $p_endposition = 0;
    }
    if($elt eq 'pos') {
        $p_pos = 0;
    }
    if($elt eq 'LinguisticNote') {
        $p_note = 0;
    }
}
  
sub hdl_char {
	my ($p, $str) = @_;

    $str =~ s/,/ /g;
    $str =~ s/°/ /g;
    if($p_name != 0) {
        $name = $str;
	}
    if($p_designator != 0) {
        $designator = $str;
    }
    if($p_upperlimit != 0) {
        $upperlimit = $str;
    }
    if($p_lowerlimit != 0) {
        $lowerlimit = $str;
    }
    if($p_upperlimitref != 0) {
        $upperlimitref = $str;
    }
    if($p_lowerlimitref != 0) {
        $lowerlimitref = $str;
    }
    if($p_beginposition != 0) {
        $beginposition = $str;
    }
    if($p_endposition != 0) {
        $endposition = $str;
    }
    if($p_pos != 0) {
        my @val = split(/ /, $str);
        if(($#val + 1) >= 2) {
            $lon += $val[0];
            $lat += $val[1];
            $numpos++;
        }
    }
    if($p_note != 0) {
        $note = $str;
    }
}
  
sub hdl_def { }

my $parser = new XML::Parser (Handlers => {
                              Start   => \&hdl_start,
                              End     => \&hdl_end,
                              Char    => \&hdl_char,
                              Default => \&hdl_def,
                            });

my $direct = "./saadir/";
opendir (DIR, $direct) or die $!;

while (my $file = readdir(DIR)) {

    if($file =~ m/\.xml/) {
        initnew();
        $parser->parsefile($direct.$file);
        $lat = $lat / $numpos;
        $lon = $lon / $numpos;
        print "$designator,$name,$upperlimit $upperlimitref,$lowerlimit $lowerlimitref,$beginposition,$endposition,$lat,$lon,$note\n";
    }
}

closedir(DIR);
