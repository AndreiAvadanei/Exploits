#!/usr/bin/perl
# comparememory.pl
# Version 0.1

use Getopt::Long;

GetOptions('help|?|' => \$help);

if ( ($help) || (! $ARGV[1]) ) {&help; }


open(INPUT, "<$ARGV[0]") || die("Could not open file $ARGV[0].\n\n");
@array = <INPUT>;
foreach $line (@array) {
	$line =~ tr/A-F/a-f/;
	chomp($line);
	@temp = split ' ', $line;
	push(@memorybytes, @temp)
}
close(INPUT);

open(INPUT, "<$ARGV[1]") || die("Could not open file $ARGV[1].\n\n");
@array = <INPUT>;

foreach $line (@array) {	
	$line =~ tr/\"\\.\; //d;
	$line =~ s/^x//;
	$line =~ tr/A-F/a-f/;
	chomp($line);	
	@temp = split 'x', $line;
	push(@shellcodebytes, @temp)
}

close(INPUT);
$counter = 0;
foreach $memorybyte (@memorybytes) {
	if ($memorybyte ne $shellcodebytes[$counter]) {
		print "Memory: $memorybyte Shellcode: $shellcodebytes[$counter] at position $counter\n";
	}
	$counter++;
}

sub help{
	print "This script compares a file containing a ASCII Text binary copy of a memory dump from OllyDbg as parameter one and compares it to a file containing shellcode in c style format as parameter two.\n\n" .
	"All diferences between the two files will be printed to the console.  No output means no differences.  Used to find bad characters when writing exploits.\n\n" .
	"Generate the ASCII Text binary output from OllyDbg by right clicking in the memory dump pane of the CPU Window, select Binary->Binary Copy, and paste the contents into a file.  The file should contain a sequence of hex characters separated by spaces.\n\n" . 
	"The Shellcode can be entered in c style format, with characters represented like so \\x55.\n\n";
	exit;
}
