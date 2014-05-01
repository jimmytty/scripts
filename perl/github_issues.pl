#!/usr/bin/env perl

use common::sense;
use List::Util qw[first max sum];
use DDP;
use JSON::XS;

my $content = do { local $/; <> };
my $json = eval { decode_json($content) };

if ($@) {
    say $content;
    exit;
}

my @no_key = (
    q(closed_at),       #
    q(comments_url),    #
    q(labels_url),      #
    q(comments),        #
    q(pull_request),    #
    q(id),              #
    q(milestone),       #
    q(url),             #
    q(events_url),      #
    q(number),          #
);

if ( ref $json ~~ q(HASH) ) {
    $json = [$json];
}

foreach my $issue (@$json) {
    foreach my $key ( keys %$issue ) {
        if ( $key ~~ @no_key ) {
            delete $issue->{$key};
        }
        elsif ( $key eq q(body) ) {
            substr( $issue->{$key}, 0, 0, qq(\n) );
        }
        elsif ( $key eq q(labels) ) {
            my @label;
            foreach my $label ( @{ $issue->{$key} } ) {
                push @label, $label->{name};
            }
            delete $issue->{$key};
            $issue->{$key} = join q(,), sort @label;
        }
        elsif ( $key ~~ [qw[user assignee]] ) {
            my $login = $issue->{$key}{login};
            delete $issue->{$key};
            $issue->{$key} = $login;
        }
    } ## end foreach my $key ( keys %$issue)
} ## end foreach my $issue (@$json)

my %label = (
    q(stopped)     => 3,     #
    q(bad capture) => 2,     #
    q(bad csv)     => 2,     #
    q(maintenance) => 2,     #
    q(bug)         => 1,     #
    q(quarantine)  => 1,     #
    q(bugfix)      => 0,     #
    q(question)    => 0,     #
    q(wontfix)     => 0,     #
    q(addition)    => -1,    #
    q(buried)      => -1,    #
    q(custom)      => -1,    #
    q(duplicate)   => -1,    #
    q(enhancement) => -1,    #
    q(fixed)       => -1,    #
    q(invalid)     => -1,    #
);

$json = [
    sort {
        max( map { $label{$_} } split /,/, $b->{labels} )
            <=> max( map { $label{$_} } split /,/, $a->{labels} )
            || $a->{updated_at} cmp $b->{updated_at}
    } @$json
];
say p $json;
