#!/usr/bin/perl -w

# needed to read a key without hitting enter
use Term::ReadKey;
ReadMode 4; # Turn off controls keys


use strict;
my($arg);

# flags set by ARGV
my($nomirror, $reset, $present) = (0,0,0);


foreach $arg (@ARGV){
		if($arg eq "--nomirror"){
				$nomirror = 1;
		}elsif($arg eq "--reset"){
				$reset = 1;
		}elsif($arg eq "--present"){
				$present = 1;
		}
}


# output names
my($lcd, $external) = ("LVDS1", "VGA1");


my($tryagain, $key) = 1;

while($tryagain){
		if($reset == 1){
				`xrandr --output $external --off`;
				`xrandr --output $lcd --auto`;
		}elsif($nomirror == 1){
				`xrandr --output $lcd --off`;
				`xrandr --output $external --auto`;
		}elsif($present == 1){
				# XXX: find largest common mode between displays
				my($mode) = "1024x768";

				`xrandr --output $lcd --mode $mode`;
				`xrandr --output $external --mode $mode`;
		}


		print "Is it safe? ";
		while (not defined ($key = ReadKey(-1))) {# No key yet
		}

		print "$key\n";

		if($key eq 'y'){
				$tryagain = 0;
		}else{
				$reset = 1;
				$nomirror = 0;
				$present = 0;
		}
}

ReadMode 0; # Reset tty mode before exiting
