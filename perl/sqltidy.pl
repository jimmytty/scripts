#!/usr/bin/env perl

use common::sense;

use SQL::Beautify;
use SQL::Tokenizer;
use SQL::ReservedWords;
use SQL::ReservedWords::DB2;
use SQL::ReservedWords::MySQL;
use SQL::ReservedWords::Oracle;
use SQL::ReservedWords::PostgreSQL;
use SQL::ReservedWords::SQLite;

my $sql_query = do { local ($/); <>; };
my @token = SQL::Tokenizer->tokenize($sql_query);
foreach my $token (@token) {
    next if length $token < 2;
    next if $token !~ m{\w}msx;
    if (   SQL::ReservedWords->is_reserved($token)
        || SQL::ReservedWords::DB2->is_reserved($token)
        || SQL::ReservedWords::MySQL->is_reserved($token)
        || SQL::ReservedWords::Oracle->is_reserved($token)
        || SQL::ReservedWords::PostgreSQL->is_reserved($token)
        || SQL::ReservedWords::SQLite->is_reserved($token) )
    {
        $token = uc $token;
    }
}
$sql_query = join q(), @token;

=for comment

use SQL::QueryBuilder::Pretty;
my $pretty = SQL::QueryBuilder::Pretty->new(
    -indent_ammount => 4,
    -indent_char    => q( ),
    -new_line       => qq(\n),
);
say $pretty->print($sql_query);

=cut

my $sql_beatify = SQL::Beautify->new(
    query       => $sql_query,
    spaces      => 4,
    space       => q( ),
    break       => qq(\n),
    wrap        => {},
    uc_keywords => 0,
);
say $sql_beatify->beautify();
