#!/usr/bin/env perl

use common::sense;
use autodie;
use Getopt::Long qw[:config no_ignore_case bundling auto_help];
use Net::OpenSSH;

my %exit_code = (
    UNKNOWN => -1,    #
    OK      => 0,     #
    WARNING => 1,     #
    FAIL    => 2,     #
);

my $opts;
my %getoption = (
    q(user|u=s)     => sub { $opts->{ $_[0] } = $_[1] },
    q(host|h=s)     => sub { $opts->{ $_[0] } = $_[1] },
    q(port|p=i)     => sub { $opts->{ $_[0] } = $_[1] },
    q(password|w=s) => sub { $opts->{ $_[0] } = $_[1] },
);
my @parameter = ( map { ( split m{\W}msx )[0] } keys %getoption );

my $result = GetOptions(%getoption);

$opts->{host} = q(127.0.0.1) unless exists $opts->{host};
$opts->{port} = 22           unless exists $opts->{port};
$opts->{user} = getpwuid $<  unless exists $opts->{user};

my %opt = map { $_ => $opts->{$_} } @parameter;

my $ssh = Net::OpenSSH->new(
    $opts->{host},    #
    %opt,             #
    default_stderr_file => q(/dev/null),    #
    timeout             => 30,              #
);

my $parameters = join q( ),
    map { exists $opts->{$_} ? sprintf( q(%s='%s'), $_, $opts->{$_} ) : () }
    @parameter;
my @msg = sprintf q(%s='%s'), q(parameters), $parameters;
my $exit_code;
if ( $ssh->error() ) {
    $exit_code = q(FAIL);
    push @msg, sprintf q(%s='%s'), q(ssh_error), $ssh->error();
}
else { $exit_code = q(OK); }

unshift @msg, sprintf q([%s]), $exit_code;
my $msg = join q( ), @msg;
say $msg;
exit $exit_code{$exit_code};
