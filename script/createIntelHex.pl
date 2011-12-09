#!/usr/bin/perl
#reads in data from stdin and writes out intel hex to stdout
use warnings;
use strict;
use Data::Dumper;
use lib qw(lib ../lib);
use Data::IntelHex;

my $allData = "";

while(my $line = <>){
	$allData .= $line;
}

my %options = (
	"lineLength" => 32,
	"padding" => 1,
	"lineEnding" => "\r\n"	#use windows format
);

my $intel = Data::IntelHex->new(\%options);

print $intel->toHex($allData);
exit(0);
