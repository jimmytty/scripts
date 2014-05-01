#!/usr/bin/perl

use strict;
use warnings q(all);
use autodie;
use Data::Dumper;

local $Data::Dumper::Sortkeys = 1;
local $Data::Dumper::Varname = q();

my $url = $ARGV[0];
open(my$fh, q(<),$ARGV[1]);
my $html = do{local $/;<$fh>};
use HTML::Miner;
my $html_miner = HTML::Miner->new(
    CURRENT_URL => $url,    #
    CURRENT_URL_HTML=>$html,#
    TIMEOUT     => 60,          #
    DEBUG       => 0,           #
);

my %break_url=();
@break_url{qw[clear_url protocol domain uri]} = $html_miner->break_url();
$Data::Dumper::Varname = q(BREAK_URL=>);print Dumper \%break_url;
$Data::Dumper::Varname = q(META_ELEMENTS=>);print Dumper $html_miner->get_meta_elements();
$Data::Dumper::Varname = q(CSS_JS=>);print Dumper $html_miner->get_page_css_and_js();

$Data::Dumper::Varname = q(IMAGES=>);print Dumper $html_miner->get_images();
$Data::Dumper::Varname = q(LINKS=>);print Dumper $html_miner->get_links();
