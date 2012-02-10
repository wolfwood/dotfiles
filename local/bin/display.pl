#!/usr/bin/perl -w

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
my($lcd, $external);

$lcd = "LVDS1";
$external = "VGA1";


if($reset == 1){
		`xrandr --output $external --off`;
		`xrandr --output $lcd --auto`;
}elsif($nomirror == 1){
		`xrandr --output $lcd --off`;
		`xrandr --output $external --auto`;
}elsif($present == 1){
		# find largest common mode between displays

		my($mode) = "1024x768";

		`xrandr --output $lcd --mode $mode`;
		`xrandr --output $external --mode $mode`;
}
