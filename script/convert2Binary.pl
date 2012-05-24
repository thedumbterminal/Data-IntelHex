#!/usr/bin/perl
#convert from intel hex to binary
use strict;
use warnings;
my $output = "";
while(my $line = <>){
	$line =~ s/(\n|\r\n)//;
	#print STDERR "got line: '" . $line . "'\n";
	if($line =~ m/^\:[A-Z0-9]{2}[A-Z0-9]{4}00([A-Z0-9]+)[A-Z0-9]{2}$/){	#only care about data records
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
