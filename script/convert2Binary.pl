#!/usr/bin/perl
#convert firmware from intel hex to binary
use strict;
use warnings;
my $output = "";
while(my $line = <>){
	$line =~ s/(\n|\r\n)//;
	if($line =~ m/^\:[A-Z0-9]{8}([A-Z0-9]{64})[A-Z0-9]{2}$/){
		$output .= pack("H*", $1);
	}
	else{
		print STDERR "Ignoring line: '" . $line . "'\n";
	}
}
$output =~ s/\x{FF}+$//;	#remove any trailing empty space
print STDERR "last part of output: '" . substr($output, -10) . "'\n";
print $output;
exit(0);