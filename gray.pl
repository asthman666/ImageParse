#!/usr/bin/perl
use strict;
use warnings;

use Image::Magick;

my ( $image, $x );

$image = Image::Magick->new;

$image->Read('o1.png','o2.png',"o3.png","o4.png","o5.png","o6.png",'o7.png','o8.png','o9.png');
$image->Quantize(colorspace => 'gray');
$image->Threshold(threshold => '70%', channel => 'All');

for (my $i = 0; $image->[$i]; $i++) {
        my $x = $image->[$i]->Write("g".($i+1).".png");
        warn $x if $x;
}

