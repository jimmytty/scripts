#!/usr/bin/env perl

use DDP;

use common::sense;
use autodie;
use warnings q(all);

local $| = 1;

my $date_range = shift;
die unless $date_range;

my ( $dt_ini, $dt_end ) = split /,/, $date_range;
$dt_end //= $dt_ini;

use List::Util qw[first];
use Storable qw[dclone];
use URI::URL;
use URI::QueryParam;
use HTTP::Tiny;
use JSON;
use HTML::Entities;

my $home = q(http://api.catracalivre.com.br);

my $uri = URI::URL->new($home);
$uri->path_segments(
    'event_time',    #
    'select',        #
    '',              #
);

$uri->query(
    'q=*%3A*&fl=post_id%2Cevent_datetime%2Cevent_time_human%2Cplace_id%2Csite_id&fq=event_datetime%3A+%5B'
        . $dt_ini
        . 'T00%3A00%3A00Z+TO+'
        . $dt_end
        . 'T00%3A00%3A00Z%2B24HOUR%5D&fq=site_code%3A+(sp+OR+geral)&fq=&wt=json&indent=off&rows=10000'
);

my $ua = HTTP::Tiny->new();

my $response = $ua->get( $uri->as_string );

my $json_dsc = eval { decode_json( $response->{content} ) };
if ($@) {
    say $@;
    say ::p $response;
    exit;
}

my %id;
my @id;
foreach my $doc ( @{ $json_dsc->{response}{docs} } ) {
    my $id = join '-', @{$doc}{qw[post_id site_id]};
    push @id, $id;
    foreach my $k (qw[event_datetime event_time_human]) {
        $id{$id}{$k} = $doc->{$k};
    }
}

my @doc;

while (@id) {
    my $id = join '+', splice @id, 0, 600;

    $uri->path_segments( 'select', '' );
    $uri->query(
        'q=place_estados.id%3A(53)&fl=post_id%2Cpost_title%2Cpost_permalink%2Cpost_excerpt%2Cpost_category%2Cpost_category_slug%2Cevent_price%2Cevent_price_numeric%2Cevent_place%2Cpost_site_referrer%2Cid&fq=id%3A('
            . $id
            . ')&fq=post_type%3A+event&fq=(site_id%3A1+OR+event_price_numeric%3A%5B*+TO+0%5D)&wt=json&rows=10000&sort=post_publish_date+desc'
    );

    $response = $ua->get( $uri->as_string() );
    $json_dsc = eval { decode_json( $response->{content} ) };
    if ($@) {
        say $@;
        say ::p $response;
        exit;
    }

    binmode STDOUT, ':utf8';
    $json_dsc = decode_json(
        do { local ( @ARGV, $/ ) = 'json.json'; <> }
    );
    my $docs = dclone $json_dsc->{response}{docs};
    foreach my $doc (@$docs) {

        my $id = delete $doc->{id};
        die ::p $doc unless $id;
        unless ( exists $id{$id} ) {
            undef $doc;
            next;
        }

        foreach my $k ( keys %{ $id{$id} } ) {
            my $v = $id{$id}{$k};
            $doc->{$k} = $v;
        }

        foreach my $delete (
            qw[id post_category post_id post_image_thumbnail post_site_referrer]
            )
        {
            delete $doc->{$delete};
        }

        foreach my $key ( keys %$doc ) {
            my $value = $doc->{$key};
            my $ref = ref $value || '';
            if (   ( $ref eq '' && $value eq '' )
                || ( $ref eq 'ARRAY' && !(@$value) )
                || ( $ref eq 'HASH'  && !(%$value) ) )
            {
                delete $doc->{$key};
            }
        }

        if ( exists $doc->{event_place} ) {
            foreach my $place ( @{ $doc->{event_place} } ) {
                my $place_dsc = decode_json($place);
                foreach my $key ( keys %$place_dsc ) {
                    my $value = $place_dsc->{$key};
                    my $ref = ref $value || '';
                    if (substr( $key, -3 ) eq '_id'
                        || (first { $key eq $_ }
                            'id',         'geolocation',
                            'mesoregion', 'place_permalink'
                        )
                        || ( $ref eq ''      && $value eq '' )
                        || ( $ref eq 'ARRAY' && !(@$value) )
                        || ( $ref eq 'HASH'  && !(%$value) )
                        )
                    {
                        delete $place_dsc->{$key};
                    }
                    elsif ( $key eq 'tipos' ) {
                        my %tipo
                            = map { lc $_->{name} => 1 }
                            @{ $place_dsc->{$key} };
                        @{ $place_dsc->{$key} } = sort keys %tipo;
                    }
                } ## end foreach my $key ( keys %$place_dsc)
                $place = $place_dsc;
            } ## end foreach my $place ( @{ $doc...})
        } ## end if ( exists $doc->{event_place...})

        if ( exists $doc->{event_price}
            && lc $doc->{event_price} =~ tr/A-Za-z//cdr eq 'catracalivre' )
        {
            next;    # Never Delete
        }

        if ( exists $doc->{event_price_numeric} ) {
            my ( $money, $currency ) = split /,/, $doc->{event_price_numeric};
            if ( $money > 0 ) {
                undef $doc;
                next;
            }
        }

    } ## end foreach my $doc (@$docs)
    push @doc, grep { defined && ref $_ } @$docs;
} ## end while (@id)

my $links_file = './catraca_livre_links.txt';
my %link;
{
    open my $fh, '<', $links_file;
    while ( my $link = <$fh> ) {
        chomp $link;
        $link{$link}++;
    }
}

open my $link_fh, '>>', $links_file;
my %orgmode;
foreach my $doc (@doc) {
    my $title = delete $doc->{post_title};
    my $link  = delete $doc->{post_permalink};

    if ( exists $link{$link} ) { next; }
    else { say $link_fh $link; }

    my %tag = map { $_ => 1 } @{ delete $doc->{post_category_slug} };
    foreach my $ev ( @{ $doc->{event_place} } ) {
        next unless exists $ev->{tipos};
        $tag{$_} = 1 foreach @{ delete $ev->{tipos} };
    }
    my @todo;
    push @todo, sprintf '** UNSEEN [[%s][%s]]%s:%s:', $link, $title, ' ' x 10,
        ( join ':', sort keys %tag );

    if ( exists $doc->{post_excerpt} ) {
        push @todo, sprintf '+ Description :: %s', delete $doc->{post_excerpt};
    }
    foreach my $price (qw[event_price event_price_numeric]) {
        next unless exists $doc->{$price};
        push @todo, sprintf '+ %s :: %s', $price, delete $doc->{$price};
    }

    my @datetime;
    foreach ( 'event_datetime', 'event_time_human' ) {
        next unless exists $doc->{$_};
        push @datetime, delete $doc->{$_};
    }
    if (@datetime) {
        if ( $datetime[1] ) {
            $datetime[1] = decode_entities( $datetime[1] );
        }
        push @todo, sprintf '+ DateTime :: %s', join ', ', @datetime;
    }

    push @todo, sprintf '+ Places ::';
    foreach my $ev ( sort { $a->{place_name} cmp $b->{place_name} }
        @{ delete $doc->{event_place} } )
    {
        my $addr = sprintf '%s, %s - %s - %s',
            map { $_ //= '' } @{$ev}{qw[logradouro numero bairro zona]};
        push @todo, sprintf '  + %s: %s', delete $ev->{place_name}, $addr;
    }

    if (%$doc) {
        push @todo, '*** DSC';
        push @todo, ::p $doc;
    }
    my $todo = join "\n", @todo;
    $orgmode{$todo}++;
} ## end foreach my $doc (@doc)

my $orgfile = "$ENV{HOME}/work/catraca_livre.org";
open my $fh, '>>:utf8', $orgfile or die $!;
select $fh;
say sprintf '* Catraca Livre - Agenda [%s TO %s]', $dt_ini, $dt_end;

say foreach sort keys %orgmode;
