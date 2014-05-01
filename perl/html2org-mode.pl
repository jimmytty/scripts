#!/usr/bin/perl

use strict;
use warnings q(all);
use utf8;
use autodie;
use Data::Dumper;

use HTML::TreeBuilder;
my $tree   = HTML::TreeBuilder->new_from_file( $ARGV[0] );
my $anchor = qq(#<<#$ARGV[0]>>);
$tree->unshift_content($anchor);

my @a = $tree->look_down( _tag => q(a), );
foreach my $a (@a) {
    my $href = $a->attr_get_i(q(href));
    if ($href) {
        foreach ($href) { s|^./||; $href =~ s|\.htm$|.html|; }
    }
    my $name = $a->attr_get_i(q(name));
    my $link = $href || $name;
    my @text = ();
    my @son  = $a->content_list();
    foreach my $son (@son) {
        if ( ref($son) ) {
            my @grandson = $son->content_list();
            foreach my $grandson (@grandson) {
                die() if ( ref($grandson) );
                push( @text, $grandson );
            }
        }
        else {
            push( @text, $son );
        }
    }

    my $text = q();
    if (@text) {
        $text = join( q(), @text );
        $text = qq([[$link][$text]]);
    }
    else { $text = qq(#<<#${link}>>); }
    $a->delete_content();
    $a->push_content($text);
} ## end foreach my $a (@a)

=for comment
my @i = $tree->look_down(
    _tag => q(i),
    sub {
        !(     $_[0]->look_down( _tag => q(b) )
            || $_[0]->look_down( _tag  => q(em) )
            || $_[0]->look_down( class => q(literal), ) );
    },
);
foreach my $i (@i) {
    my $text = $i->as_trimmed_text();
    if ($text) {
        $i->unshift_content(q(/));
        $i->push_content(q(/));
    }
}

my @b = $tree->look_down(
    _tag => q(b),
    sub {
        !(     $_[0]->look_down( _tag => q(i) )
            || $_[0]->look_down( _tag  => q(em) )
            || $_[0]->look_down( class => q(literal), ) );
    },
);
foreach my $b (@b) {
    my $text = $b->as_trimmed_text();
    if ($text) {
        $b->unshift_content(q(*));
        $b->push_content(q(*));
    }
}

my @em = $tree->look_down(
    _tag => q(em),
    sub {
        !(     $_[0]->look_down( _tag => q(i) )
            || $_[0]->look_down( _tag  => q(b) )
            || $_[0]->look_down( class => q(literal), ) );
    },
);
foreach my $em (@em) {
    my $text = $em->as_trimmed_text();
    if ($text) {
        $em->unshift_content(q(_));
        $em->push_content(q(_));
    }
}

my @class_literal = $tree->look_down(
    class => q(literal),
    sub {
        !(     $_[0]->look_down( _tag => q(i) )
            || $_[0]->look_down( _tag => q(b) )
            || $_[0]->look_down( _tag => q(em), ) );
    },
);
foreach my $class (@class_literal) {
    my $text = $class->as_trimmed_text();
    if ($text) {
        $class->unshift_content(q(~));
        $class->push_content(q(~));
    }
}
=cut

my $elinks = q(/usr/bin/elinks);
my @opts   = (
    q(-dump),    #
    q(-dump-width), q(999),    #
    q(-no-numbering),          #
    q(-no-references),         #
);

use IPC::Open3;
use Symbol q(gensym);
my ( $in, $out, $err ) = map { gensym() } ( 1 .. 3 );
if ( my $pid = open3( $in, $out, $err, $elinks, @opts ) ) {
    print( $in $tree->as_HTML() );
    close($in);
    close($err);
    while ( my $line = readline($out) ) {
        print($line);
    }
    close($out);
    waitpid( $pid, 0 );
}

$tree = $tree->delete();
