#!/usr/X11R6/bin/perl

use strict;

my $line;
my $lnum = 0;
my $round = 0;
my $nextstop = 0;
my $bootup = 0;
my $cbootup = 0;
my @stepping = (1, 5, 10, 15, 20);
my @cstepping = (1, 6, 16, 31, 51);
my @result;
my $i;

open IFILE, "<copied-vs-dedup.log" or die "Error: can't open src file";
open OFILE, ">copied-vs-dedup.data" or die "Error: can't open dest file";
while( $line = <IFILE> ) {
    chomp($line);
    $line =~ m/.*m:(\d+):(\d+):(\d+) e:(\d+):(\d+):(\d+)/;
    $bootup = ($4-$1)*3600 + ($5-$2)*60 + $6-$3;
    print "boot up time is $bootup\n"; 
    $cbootup += $bootup;
    
    if (++$lnum == $cstepping[$nextstop] + $round * $cstepping[$#cstepping]) {
        # its time to dump
	$cbootup  = $cbootup/$stepping[$nextstop];
	print "avg boot up time (for $stepping[$nextstop] VMs) is $cbootup\n";
	push (@result, $cbootup);
	$nextstop++;
	$cbootup = 0;
    }

    if ($nextstop > $#cstepping) {
        # start with the next type of experiement.
	print "reset at $lnum\n";
	$nextstop = 0;
	$round++;
    }
}

print OFILE "# auto-generated @result\n";
for ($i = 0;  $i < @cstepping; $i++) {
    my $ns1 = $i+@cstepping;
    my $ns2 = $i+2*@cstepping;
    print OFILE "$stepping[$i] $result[$i] $result[$ns1] $result[$ns2] \n"; 
}

close IFILE;
close OFILE;
