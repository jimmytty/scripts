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
);
my @parameter = ( map { ( split m{\W}msx )[0] } keys %getoption );

my $result = GetOptions(%getoption);

$opts->{host} = q(127.0.0.1) unless exists $opts->{host};
$opts->{port} = 22           unless exists $opts->{port};
$opts->{user} = getpwuid $<  unless exists $opts->{user};

my %opt = map { $_ => $opts->{$_} } @parameter;

my $ipc = IPC::PerlSSH->new(
    Host => $opts->{host},    #
    User => $opts->{user},    #
    Port => $opts->{port},    #
);

my @header = (qw[target pcent ipcent]);
my $code   = q{
my @header = splice @_;

use IPC::Open3;
use Symbol;

my ( $wtr, $rdr, $err ) = map {gensym} 1 .. 3;
my $df     = q(/usr/bin/df);
my @opt    = ( sprintf( q(--output=%s), join q(,), @header ), );

my $pid = open3( $wtr, $rdr, $err, $df, @opt );
waitpid $pid, 0;
my @stdout = readline $rdr;
my @stderr = readline $err;
undef foreach $wtr, $rdr, $err;
die if @stderr;

return @stdout;
};

$ipc->store( get_df => $code );
my @stdout = $ipc->call( q(get_df), @header );
my @df;
shift @stdout;    # removing df header
while ( my $line = shift @stdout ) {
    chomp $line;
    my @colunm = split m{\s+}, $line;
    my %partition;
    while ( my ( $i, $header ) = each @header ) {
        if ( $i > 0 ) {
            die unless $colunm[$i] =~ m{^(?<v>[0-9]+)%$};
            $colunm[$i] = $+{v};
        }
        $partition{$header} = $colunm[$i];
    }
    next if index( $partition{target}, q(/) ) != 0;
    next if index( $partition{target}, q(/dev/) ) == 0;

    push @df, {%partition};
} ## end while ( my $line = shift ...)
undef $ipc;

my %threshold = (
    q(/)   => { pcent => 80, ipcent => 80, },
    q(all) => { pcent => 95, ipcent => 99, },
);

my $exit_code;
foreach my $partition (@df) {
    my @parameter = map { sprintf q(%s='%s'), $_, $opts->{$_} } @parameter;
    my @msg;

    push @parameter, sprintf q(%s='%s'), q(target), $partition->{target};
    my $key
        = exists $threshold{ $partition->{target} }
        ? $partition->{target}
        : q(all);

    foreach my $cent (qw[pcent ipcent]) {
        my $parameter = sprintf q(%s %s='%s%%'), "@parameter", $cent,
            $partition->{$cent};
        $exit_code
            = $partition->{$cent} > ${ $threshold{$key} }{$cent}
            ? $exit_code
            = q(FAIL)
            : q(OK);
        exit $exit_code{$exit_code} if $exit_code eq q(FAIL);

        my @msg = ( sprintf( q([%s]), $exit_code ), $parameter );
        my $msg = "@msg";
        say $msg;

    } ## end foreach my $cent (qw[pcent ipcent])
} ## end foreach my $partition (@df)

exit $exit_code{$exit_code};
