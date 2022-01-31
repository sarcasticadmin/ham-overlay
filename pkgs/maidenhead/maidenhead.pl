#!/usr/bin/perl -w
# (c) 2012 Chris Ruvolo.  Licensed under a 2-clause BSD license.
if($#ARGV < 1){
  printf("Usage: $0 <lat> <long>n");
  exit(1);
}

my $lat = $ARGV[0];
my $lon = $ARGV[1];
my $grid = "";

$lon = $lon + 180;
$lat = $lat + 90;

$grid .= chr(ord('A') + int($lon / 20));
$grid .= chr(ord('A') + int($lat / 10));
$grid .= chr(ord('0') + int(($lon % 20)/2));
$grid .= chr(ord('0') + int(($lat % 10)/1));
$grid .= chr(ord('a') + int(($lon - (int($lon/2)*2)) / (5/60)));
$grid .= chr(ord('a') + int(($lat - (int($lat/1)*1)) / (2.5/60)));

print $grid;
