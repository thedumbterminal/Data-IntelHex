use strict;
use warnings;
use Test::More;
use lib qw(lib ../lib);
use Data::IntelHex;
plan(tests => 7);

{
	my %config = (
		"lineLength" => 32,
		"padding" => 0,
		"lineEnding" => "\n"
	);

	my $intel = Data::IntelHex->new(\%config);

	#1
	isa_ok($intel, "Data::IntelHex");
}

{
	my %config = (
		"lineLength" => 32,
		"padding" => 0,
		"lineEnding" => "\n"
	);

	my $intel = Data::IntelHex->new(\%config);

	#create test record should create: 0300300002337A1E
	#see http://en.wikipedia.org/wiki/Intel_HEX
	my $hex = $intel->createLine(48, 0, chr(0x02) . "3z");

	#2
	is($hex, ":0300300002337A1E\n", "createLine() Wikipedia checksum example");
}

{
	my %config = (
		"lineLength" => 16,
		"padding" => 0,
		"lineEnding" => "\n"
	);

	my $intel = Data::IntelHex->new(\%config);

	#see http://en.wikipedia.org/wiki/Intel_HEX
	#create test record should create: :100130003F0156702B5E712B722B732146013421C7
	my $hex = $intel->createLine(304, 0, chr(0x3F) . chr(0x01) . chr(0x56) . chr(0x70) . chr(0x2B) . chr(0x5E) . chr(0x71) . chr(0x2B) . chr(0x72) . chr(0x2B) . chr(0x73) . chr(0x21) . chr(0x46) . chr(0x01) . chr(0x34) . chr(0x21));

	#3
	is($hex, ":100130003F0156702B5E712B722B732146013421C7\n", "createLine() Wikipedia example");
	
	#create test record should create: :10012000194E79234623965778239EDA3F01B2CAA7
	$hex = $intel->createLine(288, 0, chr(0x19) . chr(0x4E) . chr(0x79) . chr(0x23) . chr(0x46) . chr(0x23) . chr(0x96) . chr(0x57) . chr(0x78) . chr(0x23) . chr(0x9E) . chr(0xDA) . chr(0x3F) . chr(0x01) . chr(0xB2) . chr(0xCA));

	#4
	is($hex, ":10012000194E79234623965778239EDA3F01B2CAA7\n", "createLine() Wikipedia example #2");
}

{
	my %config = (
		"lineLength" => 32,
		"padding" => 0,
		"lineEnding" => "\n"
	);

	my $intel = Data::IntelHex->new(\%config);
	my $hex = $intel->createLine(0, 4, chr(0x00) . chr(0x00));

	#5
	is($hex, ":020000040000FA\n", "createLine() for extended address record");
}

{
	my %config = (
		"lineLength" => 32,
		"padding" => 0,
		"lineEnding" => "\n"
	);

	my $intel = Data::IntelHex->new(\%config);

	#padding test

	my $hex = $intel->toHex("123456789");
	
	#6
	is($hex, ":020000040000FA\n:090000003132333435363738391A\n:00000001FF", "toHex() with short data");
}

{
	my %config = (
		"lineLength" => 32,
		"padding" => 1,
		"lineEnding" => "\n"
	);

	my $intel = Data::IntelHex->new(\%config);

	#padding test

	my $hex = $intel->toHex("123456789");
	
	#7
	is($hex, ":020000040000FA\n:20000000313233343536373839FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1A\n:00000001FF", "toHex() with short data padded");
}
