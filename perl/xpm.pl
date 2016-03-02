#!/usr/bin/env perl

use common::sense;
use warnings q(all);
use autodie;
use List::Util qw[first];
use POSIX qw[tmpnam];
use Getopt::Long qw(:config no_ignore_case auto_version);
use Pod::Usage;
use Image::Xpm;

my %opt;
my $result = GetOptions(
    q(--input_file|i=s) => sub { $opt{ $_[0] } = $_[1] },
    q(--rotate|r=s)     => sub { $opt{ $_[0] } = $_[1] },
    q(usage|help|h) => sub { pod2usage( q(-verbose) => 1 ) },
    q(man)          => sub { pod2usage( q(-verbose) => 2 ) },
);

if (@ARGV) {
    say qq(Unparsed options: '@ARGV');
    pod2usage( -verbose => 1 );
}

pod2usage( -verbose => 1 ) if !($result) || !(%opt);
pod2usage( -verbose => 1 ) unless exists $opt{input_file};
pod2usage( -verbose => 1 ) unless exists $opt{rotate};

foreach ( $opt{input_file} ) {
    die unless -e $_;
    die unless -f $_;
    die unless -r $_;
}

pod2usage( -verbose => 1 ) unless grep { $opt{rotate} eq $_ } 0, 90, 180, 270;

my $xpm = Image::Xpm->new( -file => $opt{input_file} );

my $pixels = $xpm->{-pixels};
my @matrix;
while ($pixels) {
    my $line = substr $pixels, 0, $xpm->{-width}, q();
    my @row = split //, $line;
    push @matrix, [@row];
}

if ( $opt{rotate} == 0 || $opt{rotate} == 180 ) {
    @matrix = map { [ reverse @$_ ] } @matrix;
    $xpm->{-pixels} = join q(), map { join q(), @$_ } @matrix;
}
elsif ( $opt{rotate} == 90 || $opt{rotate} == 270 ) {
    my @nm;
    for ( my $i = 0; $i <= $#matrix; $i++ ) {
        for ( my $j = 0; $j <= $#{ $matrix[$i] }; $j++ ) {
            $nm[$j][$i] = $matrix[$i][$j];
        }
    }
    if ( $opt{rotate} == 270 ) {
        @nm = reverse @nm;
    }
    $xpm->{-pixels} = join q(), map { join q(), @$_ } @nm;
    @{$xpm}{qw[-width -height]} = @{$xpm}{qw[-height -width]};
}

my $tmpfile = tmpnam();
$xpm->save($tmpfile);
my $content = do { local ( @ARGV, $/ ) = $tmpfile; readline };
unlink $tmpfile;
say $content;

=pod

=encoding utf8

=head1 USAGE

    xpm -i [FILENAME] -r [DEGREES]

    OPTIONS:
    [ --input_file | -i ]    input filename.
    [ --rotate     | -r ]    0, 90, 180, 270.

=cut
