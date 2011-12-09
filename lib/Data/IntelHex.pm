package Data::IntelHex;
use strict;
use warnings;
use Carp;
##################################################################################################
sub new{
	my($class, $params) = @_;
	my $self = {
		"__options" => {}
	};
	bless $self, $class;
	$self->__setOptions($params);
	return $self;
}
##################################################################################################
sub toHex{
	my($self, $data) = @_;
	my $hex = "";
	#create extended record
	my $address = 0;
	my $wrapCount = 0;
	#$hex .= $self->createLine($address, 4, chr(0) . chr($wrapCount));
	for(my $i = 0; $i < length($data); $i += $self->__getLineLength()){
		if($address == 0 || $address > 65535){	#at the start or bigger than 16 bit range
			$address = 0;	#rset
			$hex .= $self->createLine($address, 4, chr(0) . chr($wrapCount));
			$wrapCount++;
		}
		my $lineData = substr($data, $i, $self->__getLineLength());
		$hex .= $self->createLine($address, 0, $lineData);
		$address += $self->__getLineLength();
	}
	$hex .= ":00000001FF";	#print end record: :00000001FF
	return $hex;
}
###################################################################################################
sub createLine{
	my($self, $address, $recordType, $data) = @_;
	my $byteCount = length($data);	#find the length of the data
	if($recordType == 0 && $self->__getPadding() && $byteCount < $self->__getLineLength()){	#need to pad out data for data record type
		$data .= chr(0xFF) x ($self->__getLineLength() - $byteCount);	#append data
		$byteCount = $self->__getLineLength();	#set new length
	}
	my $line = ":";
	my $checksum = $byteCount;	#init checksum
	my $hexAddress = sprintf("%04X", $address);
	$checksum += hex(substr($hexAddress, 0, 2)) + hex(substr($hexAddress, 2, 4));	#we need to add the address to the checksum in two parts
	$checksum += $recordType;
	$line .= sprintf("%02X", $byteCount);	#add the length of the data
	$line .= $hexAddress;	#add the address of the data
	$line .= sprintf("%02X", $recordType);	#add the type of the record
	my @chars = split("", $data);	#split the data up into an array
	foreach my $char (@chars){	#deal with each binary character one at a time
		my $hexChar = sprintf("%02X", ord($char));	#convert character to hex
		$line .= $hexChar;
		#print "$checksum += " . hex($hexChar) . "\n";
		$checksum += hex($hexChar);
	}
	my $class = ref($self);
	$line .= $class->__calcHexChecksum($checksum);	
	$line .= $self->__getLineEnding();
	return $line;
}
##################################################################################################
sub __setOptions{
	my($self, $params) = @_;
	$self->{'__options'} = $params;
	return 1;
}
##################################################################################################
sub __getOptionValue{
	my($self, $key) = @_;
	return $self->{'__options'}->{$key}
}
##################################################################################################
sub __getLineLength{
	my $self = shift;
	my $length = $self->__getOptionValue('lineLength');
	if(!$length){
		confess("No line length given in options");
	}
	return $length;
}
##################################################################################################
sub __getPadding{
	my $self = shift;
	my $padding = $self->__getOptionValue('padding');
	if(!defined($padding)){
		confess("No padding given in options");
	}
	return $padding;
}
##################################################################################################
sub __getLineEnding{
	my $self = shift;
	my $ending = $self->__getOptionValue('lineEnding');
	if(!defined($ending)){
		confess("No line ending given in options");
	}
	return $ending;
}
##################################################################################################
sub __calcHexChecksum{
	my($class, $sum) = @_;
	my $hexChecksum = sprintf("%02X", (-$sum & 0xFF));		
	return $hexChecksum;
}
##################################################################################################
return 1;
