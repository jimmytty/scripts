#!/usr/bin/env perl

use common::sense;
use autodie;
use Getopt::Long qw[:config no_ignore_case];
use IO::Socket;

my %exit_code = (
    UNKNOWN => -1,    #
    OK      => 0,     #
    WARNING => 1,     #
    FAIL    => 2,     #
);

my $opts;
my %getoption = (
    q(addr|a=s)  => sub { $opts->{ $_[0] } = $_[1] },
    q(port|p=i)  => sub { $opts->{ $_[0] } = $_[1] },
    q(proto|P=s) => sub { $opts->{ $_[0] } = $_[1] },
);
my @parameter = ( map { ( split m{\W}msx )[0] } keys %getoption );
my $result = GetOptions(%getoption);

die if grep { !exists $opts->{$_} } @parameter;

my $socket = IO::Socket::INET->new(
    PeerAddr => $opts->{addr},     #
    PeerPort => $opts->{port},     #
    Proto    => $opts->{proto},    #
    Timeout  => 30,                #
);

my $exit_code;
if ( defined $socket ) {
    $socket->close();
    $exit_code = q(OK);
}
else { $exit_code = q(FAIL); }

my $parameters = join q( ), map { join q(=), $_, $opts->{$_} } @parameter;
my $msg = sprintf q([%s] %s), $exit_code, $parameters;
say $msg;
exit $exit_code{$exit_code};
