#!/usr/bin/perl

use strict;
use warnings;

use MP3::Tag;
use File::Find::Rule;
use File::Copy;

my $count=0;

my %filehash;
my %duplicatehash;

my $separator = '#####';

# Your music library directory 
my $dir = '';

# Duplicate songs will be moved here
my $movedir = '';

# Find all MP3 files in the specified directory

my @files;

print "Finding MP3 files...\n";

@files = File::Find::Rule->file()->name('*.mp3')->in($dir);

print "Found all MP3 files...\n";
print "Finding ID3 data...\n";

foreach my $file (@files) {

    my $mp3 = MP3::Tag->new($file);

    my ($title, $track, $artist, $album, $comment, $year, $genre) = $mp3->autoinfo();

    next unless $title && $artist;

    my $identifier = $title . $separator . $artist;

    $filehash{$identifier}++;
    $duplicatehash{$identifier} = $file;

}

print "Found all ID3 data...\n";
print "Moving duplicates...\n";

foreach my $identifier (keys %filehash) {

   next unless $filehash{$identifier}>1;

   my $file = $duplicatehash{$identifier};

   print "$file\n";
   move("$file","$movedir");

   $count++;

}

print "\n\nTotal duplicate songs: $count\n";

exit;

