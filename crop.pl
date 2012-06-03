#!/usr/bin/perl
use strict;
use warnings;

use Image::Magick;

my ( $image, $x );
$image = Image::Magick->new;
$x = $image->Read('g1.png',"g2.png","g3.png","g4.png","g5.png","g6.png","g7.png","g8.png","g9.png");
warn $x if $x;

$x = $image->Crop(geometry => '11x22+19+0');
warn $x if $x;

for (my $i = 0; $image->[$i]; $i++) {
    $image->[$i]->Trim();
    $x = $image->[$i]->Write("c".($i+1).".png");
    warn $x if $x;
}

@$image = ();

$image->Read("g1.png");
$x = $image->Crop('5x22+52+0');
$image->Trim();
$image->Write("c10.png");   # dot

@$image = ();

$image->Read("g1.png");
$x = $image->Crop(geometry => '11x22+57+0');
$image->Trim();
$image->Write("c0.png");

undef $image;
