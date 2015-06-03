#!/usr/bin/env perl

use common::sense;
use autodie;
use Getopt::Long qw[:config no_ignore_case bundling auto_help];
use IPC::PerlSSH;

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
    q(mem_max|M=i)  => sub { $opts->{ $_[0] } = $_[1] },
);
my @parameter = ( map { ( split m{\W}msx )[0] } keys %getoption );

my $result = GetOptions(%getoption);

$opts->{host}    = q(127.0.0.1) unless exists $opts->{host};
$opts->{port}    = 22           unless exists $opts->{port};
$opts->{user}    = getpwuid $<  unless exists $opts->{user};
$opts->{mem_max} = 80           unless exists $opts->{mem_max};

my %opt = map { $_ => $opts->{$_} } @parameter;

my $ipc = IPC::PerlSSH->new(
    Host => $opts->{host},    #
    User => $opts->{user},    #
    Port => $opts->{port},    #
);

my $code = q{
    open my $fh, q(<), q(/proc/meminfo);
    my @meminfo = readline $fh;
    chomp @meminfo;
    close $fh;
    return @meminfo;
};
$ipc->store( get_mem => $code );
my @meminfo = $ipc->call(q(get_mem));
my %meminfo;
foreach my $meminfo (@meminfo) {
    if ( $meminfo =~ m{^(\S+):\s+(\d+)\s*(k)B$}imsx ) {
        my ( $key, $value, $unity ) = ( $1, $2, $3 );
        die if $unity ne q(k);
        $value *= 1e3;
        $meminfo{$key} = $value;
    }
    else { die; }
}
undef $ipc;

my $mem_used = $meminfo{MemTotal} - $meminfo{MemFree};
my $percent  = $meminfo{MemTotal} * $opts->{mem_max} / 100;

my $exit_code = $mem_used <= $percent ? q(OK) : q(FAIL);
my $parameters = join q( ), map { join q(=), $_, $opts->{$_} } @parameter;
my $msg = sprintf q([%s] %s), $exit_code, $parameters;
exit $exit_code{$exit_code};
