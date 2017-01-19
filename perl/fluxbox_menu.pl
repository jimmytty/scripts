#!/usr/bin/env perl

use common::sense;
use warnings q(all);
use autodie qw[open close];
use File::Find;
use DDP;

my @dir = (qw[/opt/ /usr/]);
my @desktop;

find sub {
    if ( -f && substr( $_, -8 ) eq q(.desktop) ) {
        push @desktop, $File::Find::name;
    }
}, @dir;
my %key = (
    Actions      => 1,    #
    Categories   => 1,    #
    Comment      => 1,    #
    Exec         => 1,    #
    GenericName  => 1,    #
    Icon         => 1,    #
    MimeType     => 1,    #
    Name         => 1,    #
    NoDisplay    => 1,    #
    ServiceTypes => 1,    #
    Terminal     => 1,    #
    Type         => 1,    #
);
my %menu;
my %exec;
foreach my $desktop (@desktop) {
    my %desktop;
    my @category = q(-);
    open my $fh, q(<), $desktop;
    while ( my $line = readline $fh ) {
        next if index( $line, q(#) ) == 0;
        chomp $line;
        my ( $key, $value ) = split /=/, $line, 2;
        next if !( defined $key ) || !( defined $value );
        next unless exists $key{$key};
        if ( $key eq q(Categories) ) {
            @category = split /;/, $value;
        }
        else { $desktop{$key} = $value; }
    }

    next unless exists $desktop{Exec};
    next unless $desktop{Exec};
    next if $exec{$desktop{Exec}}++;

    my @entry = (
        ( exists $desktop{Name} ? sprintf q((%s)), $desktop{Name} : undef ),
        ( exists $desktop{Exec} ? sprintf q({%s}), $desktop{Exec} : undef ),
        ( exists $desktop{Icon} ? sprintf q(<%s>), $desktop{Icon} : () ),
    );

    next if ( grep { defined && $_ ne q() } @entry[ 0, 1 ] ) != 2;
    next if $entry[0] eq q((Display in Root Window));

    my $entry = join q( ) x 4, q(), q(), q([exec]), @entry;

    foreach my $category (@category) {
        $menu{$category}{$entry}++;
    }
} ## end foreach my $desktop (@desktop)

say join q( ) x 4, qw[[submenu] (UserMenu)];
foreach my $category ( sort keys %menu ) {
    say join q( ) x 4, q(), q([submenu]), qq(($category));
    foreach my $entry ( sort keys %{ $menu{$category} } ) {
        say join q( ) x 4, $entry;
    }
    say join q( ) x 4, q(), q([end]);
}
say q([end]);
