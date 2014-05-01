#!/usr/bin/perl
#Sun May  9 10:18:58 BRT 2010

use strict;
use warnings;

use POSIX qw(uname strftime);

$| = 1;

while (<>) {
    my @epoch = localtime();
    my $date = strftime(qq(%F %T), @epoch);
    my $hostname = (uname())[1];
    substr($_, 0, 0, qq(${date} ${hostname}: ));
    print();
}


