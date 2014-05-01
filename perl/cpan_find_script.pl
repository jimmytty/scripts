#!/usr/bin/perl

#==============================================================================
# Script para procurar e identificar executaveis nos modulos do CPAN
#==============================================================================

use strict;
use warnings;

use File::Find;
my @directories_to_search = (qq($ENV{HOME}/perl5/lib/));
my @packlist_path         = ();
find(
    sub {
        push( @packlist_path, qq($File::Find::dir/$_) )
            if ( $_ eq q(.packlist) );
    },
    @directories_to_search
);

my @bin_list = ();
use File::Spec;
while ( my $filename = shift(@packlist_path) ) {
    my ( $v, $path, $name ) = File::Spec->splitpath($filename);
    my @dirs = File::Spec->splitdir($path);
    @dirs = grep( $_ =~ /./, @dirs );
    my $path_trash
        = File::Spec->catpath( q(home), $ENV{USER}, q(perl5), q(lib),
        q(perl5), q(i486-linux-thread-multi), q(auto) );

    if ( index( $path, $path_trash ) ) {
        splice( @dirs, 0, 7, q(~) );
    }
    else { die(qq(unrecognized path "$path"\n)); }

    my $module = join( q(::), @dirs[ 1 .. $#dirs ] );

    open( my $fh, q(<), $filename )
        or die(qq(cannot open  file "$filename": $!\n));
    while ( my $line = <$fh> ) {
        if ( $line =~ m|/bin/| ) {
            chomp($line);
            my $item = qq($module => $line);
            $item =~ s|/home/jimmy|~|;
            push( @bin_list, $item );
        }
    }
    close($fh);
} ## end while ( my $filename = shift...)

@bin_list = sort(@bin_list);

while ( my $item = shift(@bin_list) ) { print(qq($item\n)); }
