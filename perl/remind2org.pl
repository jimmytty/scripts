#!/usr/bin/env perl

use common::sense;
use warnings q(all);
use IPC::Open3;
use Symbol qw[gensym];
use Time::Piece;
use Time::Seconds;
use DDP;
use Remind::Parser;

my $orgfile = qq($ENV{HOME}/org/reminders.org);
open my $rfh, q(<), $orgfile or die $!;
my @org = map { split /\n(?=[*])/ } do { local $/ = undef; <$rfh> };
close $rfh;

my %org;
foreach my $org (@org) {
    my $title = ( split /\n/, $org, 2 )[0];
    foreach ($title) {
        s/^[*]+\s+//;
        s/^(?:TODO|DONE)\s+//;
        s/\s+:(?:[^:]+:)+$//;
    }
    die $title if exists $org{title};
    $org{$title} = $org;
}

my @cmd = (qw[/usr/bin/rem -l -p]);
my ( $wtr, $rdr, $err ) = map {gensym} 1 .. 3;
my $pid = open3( $wtr, $rdr, $err, @cmd );
waitpid $pid, 0;
close $wtr;
close $err;

my $remind = Remind::Parser->new();
$remind->parse($rdr);
close $rdr;
my $reminders   = $remind->reminders();
my $epoch_limit = Time::Piece->new->epoch() + ONE_DAY * 7;

my %task;
foreach my $rem (@$reminders) {
    my $rem_date = Time::Piece->strptime( $rem->{date}, q(%Y%m%d) );
    if ( $rem_date->epoch() > $epoch_limit ) {
        next;
    }

    $rem->{description} =~ s/^[*](?=[^*])// or next;
    my @tag = ( ( $rem->{file} =~ m{^.*/(.*?)(?:\.rem)?$}imsx )[0], );

    my $title = sprintf q(%s %s), @{$rem}{qw[description date]};
    next if exists $org{$title};

    my @task = (
        sprintf( q(* TODO %s  :%s:), $title, join( ':', @tag ) ),
        sprintf( q(  DEADLINE: <%s %s>), $rem->{date}, $rem_date->wdayname ),
    );
    $task{$title} = join qq(\n), @task;
} ## end foreach my $rem (@$reminders)

exit 0 unless %task;

open my $wfh, q(>), $orgfile or die $!;
foreach my $task ( sort values %org, values %task ) {
    say $wfh $task;
}
close $wfh;
