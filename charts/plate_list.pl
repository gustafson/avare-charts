#!/usr/bin/perl
# Run this script on the plates folder to find a list of plates that will 
# be exported to geo tagging list on the server. This takes in list.txt
# formatted as:
# AK/ENN/RNAV-GPS-RWY-04L.png
# ...

 open (MYFILE, 'list.txt');
 my @array;
 my $index = 0;
 while (<MYFILE>) {
 	chomp;
    @data = split(/\//, $_);
    if (
        ($data[2] =~ /^ILS-/) or
        ($data[2] =~ /^HI-ILS-/) or
        ($data[2] =~ /^VOR-/) or
        ($data[2] =~ /^LDA-/) or
        ($data[2] =~ /^RNAV-/) or
        ($data[2] =~ /^NDB-/) or
        ($data[2] =~ /^LOC-/) or
        ($data[2] =~ /^HI-LOC-/) or
        ($data[2] =~ /^SDA-/) or
        ($data[2] =~ /^GPS-/) or
        ($data[2] =~ /^TACAN-/) or
        ($data[2] =~ /^HI-VOR/) or
        ($data[2] =~ /^HI-TACAN/) or
        ($data[2] =~ /^COPTER-/) or
        0
        ) {
            if(
                ($data[2] !~ /-CONT/)
            ) {   
                $array[$index] = "$_\n";
                $index++;
            }
    }

 }
 close (MYFILE); 
 print sort @array;
