#!/usr/bin/perl
##############################################
# Reap Files (script)
#
# http://www.mikealeonetti.com/wiki/index.php/Download_all_files_on_a_website_perl_script
#
# Project started 11/03/2010
#
# Copyright (c) 2011 Mike A. Leonetti
# All rights reserved.
#
# This package is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
##############################################

use strict;
use Getopt::Std;

use HTML::Entities;

my @download_files = ();
my $error_log = '';
my %opts;
my @extensions;

sub attempt_download($$$);
sub read_files($$);
sub print_error($);

sub add_slash($);

getopts( "vhf:", \%opts );

print <<EOF;
Web page parser and file fetcher.

By Mike A. Leonetti

EOF

if( $opts{'h'} )
{
print <<EOF;
Usage: $0 -f extensions site1 [site2] [site3] ...
  -h    Print this message
  -f    File extensions to search for (comma separated list)
  -v    Causes wget output to be displayed
EOF
exit( 0 );
}

unless( defined $opts{'f'} )
{
	print( "At least one file extension is required (-f).  See help (-h) for more information.\n" );
	exit( 1 );
}

@extensions = split( /\s*,\s*/, $opts{'f'} );

print( "STAGE 1: Finding files on the page.\n\n" );
foreach( @ARGV )
{
	print( "Reading files from \"$_\"...\n" );
	my $page = qx/wget -q -t 10 -O - $_/;
	unless( $? )
	{
		my $found_count = read_files( $page, $_ );
		print( "Found ".$found_count." files.\n" );
	}
	else
	{
		print( "Retrieving $_ failed. Skipping." );
	}
}

print( "STAGE 2: Fetching files with the extensions provided.\n\n" );
foreach my $file (@download_files)
{
	if( -e $file->{'file'} )
	{
		print( $file->{'file'}." (".$file->{'name'}.") already exists. Skipping.\n" );
		next;
	}

	print( "Downloading ".$file->{'file'}." (".$file->{'name'}.").\n" );
	attempt_download( $file->{'url'}, $file->{'file'}, $file->{'name'} );
}

if( length($error_log) )
{
	print( "Completed with errors.\n\nERRORS:\n" );
	print( $error_log."\n" );
}
else
{
	print( "Completed with no errors.\n" );
}

sub attempt_download( $$$ )
{
	my $url = shift;
	my $file_name = shift;
	my $link_name = shift;

	my $download_temp_name = "download_temp";

	# Try first the original URL
	$_ = "wget ".( $opts{'v'} ? "" : "-q" )." -t 10 -O ".$download_temp_name." ".$url;
	system( $_ );
	unless( -e $download_temp_name )
	{
		print_error( "Unable to get file ".$file_name." (".$link_name.")" );
		return();
	}

	if( `file $download_temp_name` =~ /gzip/ )
	{
		system( "zcat ".$download_temp_name." > ".$file_name );
		if( $? )
		{
			print_error( "Unable to unzip ".$file_name." (".$link_name.")" );
		}
		unlink( $download_temp_name );
	}
	else
	{
		rename( $download_temp_name, $file_name );
	}
}

sub read_files($$)
{
	my $page = shift;
	my $base_url = shift;

	if($base_url =~ /([^:]*:\/\/)?([^\/]+\.[^\/]+)/g) {
	  $base_url = $2;
	}

	my $count = 0;

	while( $page=~/<a [^>]*?href=\"([^\"]+)\".*?>(.*?)<\/a>/gi )
	{
		#print( "File $1, name $2, pos ".pos($page)."\n" );
		# Correct the web URL
		my( $url_found, $title_found ) = ( $1, $2 );

		# Check to see if it's Javascript
		next if( $url_found=~/^javascript:/ );
		# Weed out anchors
		next if( index( $url_found, "#" )!=-1 );

		# Check to see if it's relative link
		if( $url_found!~/^\w+:\/\// )
		{
			# Remove slash if there is one on the link
			$url_found = substr( $url_found, 1 ) if( substr( $url_found, 0, 1 ) eq "/" );
			# Add a slash if there is none
			$url_found = add_slash( $base_url ).$url_found;
		}
		else
		{
			# Now check to see if this isn't a file but a main webpage
			next if( $url_found=~/^(\w+):\/\/[^\/]+\/?$/ );

			$url_found =~ /^(\w+):/;
			my $protocol = lc( $1 );
			# Check to see if we can handle it
			next unless( $protocol eq "http" or $protocol eq "https" or $protocol eq "ftp" );
		}

		# Decode the URL
		decode_entities( $url_found );

		# Get the filename
		next unless( $url_found =~ /\/([\w\-_\%\.]+\.([\w\-_\%]+))$/ );

		# Filename is contained in $1
		my $file_name = $1;
		my $extension = $2;

		# Check to see if we want this extension
		next unless( grep $_ eq $extension, @extensions );

		# Parse out % special vars
		$file_name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		decode_entities( $file_name );

		$count++;
		push( @download_files, { 'file'=>$file_name, 'name'=>$title_found, 'url'=>$url_found } );
	}
	return( $count );
}
sub print_error($)
{
	print( "ERROR: ".$_[0] );
	$error_log.= "\n" if( length($error_log) );
	$error_log.= $_[0];
}

sub add_slash($)
{
	if( substr( $_[0], -1 ) ne "/" )
	{
		return( $_[ 0 ]."/" );
	}

	return( $_[ 0 ] );
}
