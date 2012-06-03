#!/usr/bin/perl
use strict;
use warnings;

use Imager;
use Image::Seek qw(loaddb add_image query_id savedb);

loaddb('imagedata.db');

foreach my $k (0..10) {
	my $img = Imager->new();
	my $file = "c$k.png";
	$img->open(file => $file) or die "Cannot read $file: " . $img->errstr;
	
	add_image($img, $k);
	savedb('imagedata.db');
}
