#!/usr/bin/perl
use strict;
use warnings;

use Imager;
use Image::Magick;
use Image::Seek qw(loaddb add_image query_id savedb remove_id);
use Data::Dumper;
use LWP::UserAgent;

my $url = shift;

exit 0 unless $url;

my $ua = LWP::UserAgent->new;
my $resp = $ua->get($url);
my $content = $resp->decoded_content();
$content =~ m{<div class="p-price"><img.*?src ="(.*?)"/></div>};
my $image_url = $1;

print $image_url, "\n";
exit 0 unless $image_url;

my $file = './ex.png';
$ua->get($image_url, ':content_file' => $file);

loaddb("imagedata.db");

my ( $image, $x );
$image = Image::Magick->new();

my @nums;

my $next_x = 19;

my $dian;

foreach ( 0..20 ) {
    $dian++ if $dian;

    $x = $image->Read('ex.png');
    warn $x if $x;

    $x = $image->Quantize(colorspace => 'gray');
    warn $x if $x;

    $x = $image->Threshold(threshold => '70%', channel => 'All');
    warn $x if $x;

    $x = $image->Crop(geometry => "11x22+$next_x+0");
    warn $x if $x;

    $image->Trim();

    if (checkdian($image)) {
	my $unit = 5;
	$x = $image->Crop(geometry => $unit . "x22+".$next_x .'+0');
	warn $x if $x;
	
	$x = $image->Trim();
	$dian = 1;
	
	$next_x += $unit;
    } else {
	$next_x += 11;
    }
    
    $image->Write("p$_.png");

    @$image = ();

    my $img = Imager->new();
    $img->open(file => "p$_.png");
    add_image($img, -1);
    savedb("imagedata.db");

    my @results = query_id(-1, 2);

    remove_id(-1);

    #print Dumper \@results;

    foreach my $arr ( @results ) {
	if ( $arr->[0] != -1 ) {
	    if ( $arr->[0] == 10 ) {
		push @nums, ".";
	    } else {
	        push @nums, $arr->[0];
	    }
	    last;
	}
    }
    last if $dian && $dian > 2;
}

sub check4 {
    my $image = shift;

    my $i;

    foreach ( 0..9 ) {
	my $pix = int $image->GetPixel('x' => $_, 'y' => 7);
	if ( $pix == 0 ) {
	    $i++;
	}
    }

    return 1 if $i && $i == 10;
}

sub check1 {
    my $image = shift;
    my $i;

    foreach my $x ( 2..3 ) {
	foreach my $y ( 0..10 ) {
	    my $pix = int $image->GetPixel('x' => $x, 'y' => $y);
	    if ( $pix == 0 ) {
		$i++;
	    }
	}
    }

    return 1 if $i && $i == 22;
}

sub checkdian {
    my $image = shift;
    my $i;

    foreach my $x ( 0..1 ) {
	foreach my $y ( 8..10 ) {
	    my $pix = int $image->GetPixel('x' => $x, 'y' => $y);
	    if ( $pix == 0 ) {
		$i++;
	    }
	}
    }

    return 1 if $i && $i == 6;
}

print join("",@nums) . "\n";
