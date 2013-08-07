#!/usr/bin/perl
# generatecodes.pl
# Version 0.1

use Getopt::Long;

GetOptions('help|?|' => \$help);

if ($help) {&help; }

if ($ARGV[0]) {
	@knownbad = split ',', $ARGV[0];
	foreach $bad (@knownbad) {
		$bad = hex($bad);
	}
}

if (! $ARGV[1]) {
	$split = 15; # split at 15 characters if not told otherwise
} else {
	$split = $ARGV[1];
}

$count=0;
for ($a = 0; $a <= 255; $a++) {
	$match = 0;
	foreach $knownbad (@knownbad) {
		if ($knownbad eq $a) {$match = 1} 
	}
	if (! $match) { 
		if (! $count) {print chr(34); }
		print '\x' . sprintf("%02x", $a); 
		$count++;
	}
	
	if ( (int($count/$split) eq $count/$split ) && ($count)) {print chr(34) . "\n"; $count = 0; }
}

if ( (int($count/$split) ne $count/$split ) && ($count)) {print chr(34) . "\n";}


sub help{
	print "This script generates a c style buffer of all characters from 0 to 255, except those specified in a comma seperated list provided as parameter one.  Used to generate a list of characters to enter into a exploit to test for bad characters. \n\n" .
	"Parameter one is optional and should contain comma separated hexadecimal bytes in the format 00,0a,0d and any characters provided will not be listed in the output.\n\n" .
	"Parameter two is also optional and specifies the interval at which new lines are interspersed in the output.  If not specified the default is a new line every 15 characters.\n\n";
	exit;
}