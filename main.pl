#!/usr/bin/env perl
#===============================================================================
#
#         FILE: main.pl
#
#        USAGE: ./main.pl
#
#  DESCRIPTION: a
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (),
# ORGANIZATION:
#      VERSION: 1.0
#      CREATED: 07/07/15 13:49:55
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use DateTime::Format::Strptime;
use DateTime;

my $filename      = $ARGV[0];
my $secondsToAdd  = $ARGV[1];

open(my $fh, $filename)
  or die "Could not open file '$filename' $!";

my $init;
my $end;
my $newRow;

my $strp = DateTime::Format::Strptime->new(
  pattern   => '%T',
  on_error => 'croak',
);

while (my $row = <$fh>) {
  chomp $row;
  if ($row =~ m/.*(\d\d:\d\d:\d\d).*(\d\d:\d\d:\d\d).*/) {
    my $strInit = $1;
    my $strEnd  = $2;

    $row = substituteInLine($row, $1, $2);
  }

  print "$row\n";
}

sub substituteInLine {
  my ($row, $from, $to) = @_;
  my $init;
  my $end;
  my $newRow;

  $init = $strp->parse_datetime($from)
            ->add(seconds => $secondsToAdd)
            ->hms;
  $end = $strp->parse_datetime($to)
            ->add(seconds => $secondsToAdd)
            ->hms;

  $newRow = $row =~ s/$from/$init/r;
  $newRow = $newRow =~ s/$to/$end/r;

  return $newRow;
}


