#!/usr/bin/perl
#reads in data from stdin and writes out intel hex to stdout
use warnings;
use strict;
use Data::Dumper;
use Math::BigInt;
use lib qw(lib ../lib);

my $line = $ARGV[0];

if($line =~ m/^(\:)([A-Z0-9]{2})([A-Z0-9]{4})([A-Z0-9]{2})([A-Z0-9]+)([A-Z0-9]{2})$/){
	my $startCode = $1;
	my $byteCount = $2;
	my $address = $3;
	my $recordType = $4;
	my $data = $5;
	my $checksum = $6;

	my $newChecksum = 0;
	print "$newChecksum + " . hex($byteCount) . " byte count\n";
	$newChecksum += hex($byteCount);
	print "address: $address\n";
	print "$newChecksum + " . substr($address, 0, 2) . " + " . substr($address, 2, 4) . " address\n";
	
	$newChecksum += hex(substr($address, 0, 2)) + hex(substr($address, 2, 4));
	print "$newChecksum + " . hex($recordType) . " record type\n";

	$newChecksum += hex($recordType);

	#print Dumper $data;
	my $i = 0;
	do{
		my $pair = substr($data, $i, 2);
		print "$newChecksum + " . hex($pair) . " data: $pair\n";
		$newChecksum += hex($pair);
		$i = $i + 2;
	}
	while(($i + 2) <= length($data));

	print "$newChecksum before 2 complement\n";
	#$newChecksum = (-$newChecksum & 0xFF);
	my $math = Math::BigInt->new($newChecksum);
	$newChecksum = $math->bnot();
	print "$newChecksum after 2 complement\n";
	my $hexChecksum = sprintf("%02X", $newChecksum);
	print substr($hexChecksum, (length($hexChecksum) - 2)) . " in hex\n";
}
else{
	die("Invalid line");
}

exit(0);
