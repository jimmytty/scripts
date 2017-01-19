#!/usr/bin/env perl

use common::sense;
use File::Spec::Functions qw[catdir];
use Encode;
use DDP;

use DBI;
use Business::BR::CNPJ (
    q(test_cnpj),      #
    q(canon_cnpj),     #
    q(format_cnpj),    #
    q(parse_cnpj),     #
    q(random_cnpj),    #
);

my $arg = $ARGV[0] // readline;
my $cnpj = $arg;
$cnpj =~ tr{0-9}{}cd;

unless ( test_cnpj( format_cnpj($cnpj) ) ) {
    say sprintf q(ERROR: invalid cnpj: '%s'), $arg;
    exit 1;
}

my $dbfile = catdir( $ENV{HOME}, qw[.sqlite dados.db] );

my @dsn = (
    [ scheme     => q(dbi), ],
    [ driver     => q(SQLite), ],
    [ driver_dsn => join( q(=), q(dbname), $dbfile ), ],
);

my $dsn = join q(:), map { $_->[1] } @dsn;
my $dbh = DBI->connect($dsn) or die DBI->errstr();
my $table = q(cnpjreva);

my $sth = $dbh->column_info( undef, q(main), $table, undef, {} );
my @header;
while ( my $row = $sth->fetchrow_hashref() ) {
    push @header, $row->{COLUMN_NAME};
}

my @sql = (
    [ SELECT => q(*), ],
    [ FROM   => $table, ],
    [ WHERE  => [ q(cnpj), q(=), $cnpj, ], ],
);

my $sql = join q( ),
    map { ref $_->[1] ? ( $_->[0], @{ $_->[1] } ) : @{$_} } @sql;
$sth = $dbh->prepare($sql);
$sth->execute();
while ( my $row = $sth->fetchrow_hashref() ) {
    foreach my $key (@header) {
        my $value = $row->{$key};
        if ( defined $value ) {
            if ( $value eq q() ) { $value = q(`'); }
        }
        my $line = join q( => ), $key, $value;
        if ( !( exists $ENV{LANG} )
            || index( lc $ENV{LANG}, q(.utf8) ) == -1 )
        {
            $line = decode_utf8($line);
        }
        say $line;
    }
} ## end while ( my $row = $sth->fetchrow_hashref...)
