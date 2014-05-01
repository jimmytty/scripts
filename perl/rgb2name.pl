#!/usr/bin/perl

use strict;
use warnings q(all);

use Data::Dumper;
use Color::Library;
use Color::Library::Dictionary;
my $dictionaries = Color::Library->dictionaries();
my @dictids      = keys( %{$dictionaries} );

# criando o dicionario dinamicamente
my %rgb2name = ();
for my $dictid (@dictids) {
    my @colors = Color::Library->dictionary($dictid)->colors();
    for my $color (@colors) {
        push( @{ $rgb2name{ $color->_hex } }, $color->id );
        push( @{ $rgb2name{ $color->id } },   $color->_hex );
    }
}

# realizando a consulta
my $rgb = $ARGV[0];
$rgb =~ tr/A-Z/a-z/;

if ( exists( $rgb2name{$rgb} ) ) {
    for my $name ( sort( @{ $rgb2name{$rgb} } ) ) {
        print(qq($name\n));
    }
}
else {
    my $flag = 0;
    foreach my $name ( sort( keys(%rgb2name) ) ) {
        if ( index( $name, $rgb ) != -1 ) {
            for my $hex ( sort( @{ $rgb2name{$name} } ) ) {
                print(qq($name => $hex\n));
            }
            $flag = 1;
        }
    }
    print(qq(Not found.\n)) if ($flag);
}
