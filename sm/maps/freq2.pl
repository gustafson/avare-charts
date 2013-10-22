#!/usr/bin/perl
#Copyright (c) 2012, Zubair Khan (governer@gmail.com)
#Jesse McGraw (jlmcgraw@gmail.com)
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

my $debug = 0;

# Right trim function to remove trailing whitespace
sub rtrim($) {
    my $string = shift;
    $string =~ s/\s+$//;
    return $string;
}

# Left trim function to remove leading whitespace
sub ltrim($) {
    my $string = shift;
    $string =~ s/^\s+//;
    return $string;
}

sub cleantext {
    my ( $freq, $type, $tower_name, $approach_name, $departure_name ) = @_;

    # $type =~ s/\s*\/P/1/g;
    # $type =~ s/\s*\/S/2/g;
    #Add a space after a VHF frequency
    $freq =~ s/(1[1-3][0-9]\.\d{1,3})(\b)/$1 $2/g;
    #Add degree marks to a sector indicator
    #(ddd-ddd)
    #$freq =~s/\(([0-3][0-9][0-9])\)[-]\(([0-3][0-9][0-9])\)/$1°-$2°/g;

    if ( $type =~ m/LC|LCL/ ) {
        $freq = $freq . " (" . $type . ")";
        $type =
          ( $tower_name ne "" ? "Tower" . " (" . $tower_name . ")" : "Tower" );
    }
    elsif ( $type =~ m/GND|GROUND/ ) {
        $freq = $freq . " (" . $type . ")";
        $type = "Ground";
    }
    elsif ( $type =~ m/CD|CLNC.DEL/ ) {
        $freq = $freq . " (" . $type . ")";
        $type = "Clearance Delivery";
    }
    elsif ( $type =~ "ATIS" ) {
    }
    elsif ( $type =~ m/APCH|APP/ && $type =~ m/DEP/ ) {
        $freq = $freq . " (" . $type . ")";
        $type =
          ( $approach_name ne ""
            ? "Apch/Dep" . " (" . $approach_name . ")"
            : "Apch/Dep" );
    }
    elsif ( $type =~ m/APCH/ ) {
        $freq = $freq . " (" . $type . ")";
        $type =
          ( $approach_name ne ""
            ? "Approach" . " (" . $approach_name . ")"
            : "Approach" );
    }
    elsif ( $type =~ m/DEP/ ) {
        $freq = $freq . " (" . $type . ")";
        $type =
          ( $departure_name ne ""
            ? "Departure" . " (" . $departure_name . ")"
            : "Departure" );
    }
    #Expand some abbreviations
    $type =~ s/RDR/RADAR/g;

    $freq = ltrim( rtrim($freq) );
    $type = ltrim( rtrim($type) );
    #All whitespace to one space
    $freq =~ s/\s{2,}/ /g;
    return ( $freq, $type );
}

my $airport_count = 0;
my $filename      = "TWR.txt";

open my $file, '<', $filename or die "can't open '$filename' for reading : $!";

my @towerarray = <$file>;    # Reads all lines into array

foreach (@towerarray) {

    #sanitize input text for output to csv
    $_ =~ s/,|"/ /g;
    if (m/^TWR1/) {

        #Find each tower/airport defintion
        $airport_count++;

        print "New airport #$airport_count\n" if $debug;
        print
"--------------------------------------------------------------------\n"
          if $debug;
        my $tcfi           = ltrim( rtrim( substr( $_, 4,   4 ) ) );
        my $apt_id         = ltrim( rtrim( substr( $_, 18,  11 ) ) );
        my $tower_name     = ltrim( rtrim( substr( $_, 804, 26 ) ) );
        my $approach_name  = ltrim( rtrim( substr( $_, 856, 26 ) ) );
        my $departure_name = ltrim( rtrim( substr( $_, 908, 26 ) ) );

        #print "$tcfi,$apt_id,$tower_name,$approach_name,$departure_name\n";

        foreach (@towerarray) {

            #sanitize input text for output to csv
            $_ =~ s/,|"/ /g;

#Loop through the whole file for each tower/airport found above since the records might not be grouped together. 
#Maybe there's a better way to do this but this works for now
            if ( m/^TWR3/ && ( $tcfi eq ltrim( rtrim( substr( $_, 4, 4 ) ) ) ) )
            {
                #TWR3 records are a list of frequencies for the airport
                #This iterates through each of the frequency records in the overall TWR3 record
                my $cut = substr( $_, 8, length($_) );
                while ( length($cut) > 93 ) {
                    my $freq = ltrim( rtrim( substr( $cut, 0,  44 ) ) );
                    my $type = ltrim( rtrim( substr( $cut, 44, 50 ) ) );
                    $cut = substr( $cut, 94, length($cut) );

                    #ignore this line if the TYPE doesn't contain a letter
                    next if ( !( $type =~ m/[A-Za-z]/ ) );

                    #ignore this line if TYPE contains anything that looks like a frequency (meaning it's probably misformatted)
                    next if ( $type =~ m/(\d{3}\.\d{1,3})/ );

                    #ignore this line if FREQ doesn't contain a valid VHF Aviation frequency
                    next
                      if !( $freq =~ m/(1[1-3][0-9]\.\d{1,3})/
                        && ( $1 >= 118 && $1 < 137 ) );

                    ( $freq, $type ) =
                      cleantext( $freq, $type, $tower_name, $approach_name,
                        $departure_name );
                    print "$tcfi,$type,$freq\n";
                }

            }
            if ( m/^TWR7/
                && ( $apt_id eq ltrim( rtrim( substr( $_, 102, 11 ) ) ) ) )
            {
                #TWR7 records are for satellite airport data
                #But they also display information about our own frequencies (eg approach and departure)
                #The plan here is to only print frequencies for this airport, not what it may be providing to others
                my $freq = ltrim( rtrim( substr( $_, 8,  44 ) ) );
                my $type = ltrim( rtrim( substr( $_, 50, 52 ) ) );

                #ignore this line if the type doesn't contain a letter
                next if ( !( $type =~ m/[A-Za-z]/ ) );

                #ignore this line if type contains anything that looks like a frequency (meaning it's probably misformatted)
                next if ( $type =~ m/(\d{3}\.\d{1,3})/ );

                #ignore this line if frequency doesn't contain a valid VHF Aviation frequency
                next
                  if !( $freq =~ m/(1[1-3][0-9]\.\d{1,3})/
                    && ( $1 >= 118 && $1 < 137 ) );

                ( $freq, $type ) =
                  cleantext( $freq, $type, $tower_name, $approach_name,
                    $departure_name );
                print "$tcfi,$type,$freq\n";
            }
            
            if ( m/^TWR6/ && ( $tcfi eq ltrim( rtrim( substr( $_, 4, 4 ) ) ) ) )
            {
                #TWR6 records are for remarks
                my $remark = ltrim( rtrim( substr( $_, 13, length($_) ) ) );

                print "$tcfi,Remarks,$remark\n";
            }

          # if ( m/^TWR4/ && ( $tcfi eq ltrim( rtrim( substr( $_, 4, 4 ) ) ) ) )
          # {
          # #TWR4 records are for services for satellite airpoirts
          # my $remark = ltrim( rtrim( substr( $_, 8, 100) ) );

          # print "$tcfi,T4,$remark\n";
          # }
          # if ( m/^TWR2/ && ( $tcfi eq ltrim( rtrim( substr( $_, 4, 4 ) ) ) ) )
          # {
          # #TWR2 are for operating hours
          # my $militaryhours   = ltrim( rtrim( substr( $_, 408,  200 ) ) );
          # my $approachhours1  = ltrim( rtrim( substr( $_, 608,  200 ) ) );
          # my $approachhours2  = ltrim( rtrim( substr( $_, 808,  200 ) ) );
          # my $departurehours1 = ltrim( rtrim( substr( $_, 1008, 200 ) ) );
          # my $departurehours2 = ltrim( rtrim( substr( $_, 1208, 200 ) ) );
          # my $towerhours      = ltrim( rtrim( substr( $_, 1408, 200 ) ) );

# # print "$tcfi,T2,$militaryhours,$approachhours1,$approachhours2,$departurehours1,$departurehours2,$towerhours\n";
# }

        }

    }

}
close($file);

