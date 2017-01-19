#!/usr/bin/env perl

use common::sense;
use warnings q(all);
use open IO => q(:locale);
use Getopt::Long qw(:config no_ignore_case auto_version);
use Time::Piece;
use DDP;

sub caps {
    my $string = shift;

    $string = lc $string;
    my @char = split //, $string;
    my @word;

    push @word, uc $string;
    my $binary = eval sprintf q(0b%s), 1 x @char;
    while ( --$binary ) {
        my @binary = split //, sprintf q(%0*b), $#char + 1, $binary;
        my @nword;
        while ( my ( $index, $value ) = each @binary ) {
            my $char = $value ? uc $char[$index] : $char[$index];
            push @nword, $char;
        }
        push @word, join q(), @nword;
    }

    say p @word;

    return @word;
} ## end sub caps

sub leet {
    my $string = shift;

    my %leet_charset = (
        A => [4],
        a => [4],
        b => [6],
        B => [8],
        E => [3],
        e => [3],
        F => [q(ph)],
        G => [6],
        g => [9],
        L => [1],
        l => [1],
        O => [0],
        o => [0],
        S => [ 5, q($) ],
        s => [ 5, q($) ],
        T => [7],
        t => [7],
        W => [q(vv)],
        w => [q(vv)],
        Z => [2],
        z => [2],
    );

    my @word;
    my @char = split //, $string;
    for ( my $i = 0; $i <= $#char; $i++ ) {
        my $char;
        if ( exists $leet_charset{ $char[$i] } ) {
            if ( @{ exists $leet_charset{ $char[$i] } } > 1 ) {
                $char = $leet_charset{ $char[$i] };
            }
            else { $char = $leet_charset{ $char[$i] }[0]; }
        }
        else { $char = $char[$i] }
        push @word, $char;
    }

    say p @word;

} ## end sub leet

my @separator = ( q( ), qw[_=+@-] );
my $opts;
my $result = GetOptions(
    q(names=s)      => sub { $opts->{ $_[0] } = $_[1] },
    q(profile=s)    => sub { $opts->{ $_[0] } = $_[1] },
    q(dates=s)      => sub { $opts->{ $_[0] } = $_[1] },
    q(date_style=s) => sub { $opts->{ $_[0] } = $_[1] },
    q(length=s)     => sub { $opts->{ $_[0] } = $_[1] },
);

if ( exists $opts->{profile} ) {
    die;
}

my @pwd_len = ( 4, 8 );    # defaults
if ( exists $opts->{length} ) {
    my @length = split /,/, $opts->{length};
    $pwd_len[0] = $length[0] if $length[0];
    $pwd_len[1] = $length[1] if $length[1];
    die if $pwd_len[1] < $pwd_len[0];
}
@{ $opts->{length} } = @pwd_len;

if ( exists $opts->{names} ) {
    my %name = map { $_ => 1 } split /,/, delete $opts->{names};
    @{ $opts->{names} } = keys %name;
}

# say p $opts;

foreach my $word ( caps( $opts->{names}[0] ) ) {
    foreach my $sep ( q(), qw[_ -] ) { }
}

# leet( $opts->{names}[0] );
