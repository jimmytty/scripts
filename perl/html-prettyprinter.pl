#!/usr/bin/env perl

use strict;
use warnings q(all);

local $/ = undef();
my $html_code = <>;

use HTML::TreeBuilder;
my $tree = HTML::TreeBuilder->new();
$tree->store_comments(1);
$tree->store_declarations(1);
$tree->store_pis(1);
$tree->parse_content($html_code);

use HTML::PrettyPrinter;
my %options = (
    uppercase       => 0,
    linelength      => 1024,
    quote_attr      => 1,
    wrap_at_tagend  => q(ALWAYS),
    allow_forced_nl => 1,
);
my $hpp = HTML::PrettyPrinter->new(%options);
#$hpp->allow_forced_nl(1);
my @tags = qw(head body table a div ul li span br hr p form input);
$hpp->set_nl_before(1,@tags);
$hpp->set_nl_after(1,@tags);

print @{ $hpp->format($tree) };

$tree = $tree->delete();
