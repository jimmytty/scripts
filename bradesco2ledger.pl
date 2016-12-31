#!/usr/bin/env perl

use common::sense;
use warnings q(all);
use experimental qw[smartmatch];
use English qw[-no_match_vars];
use List::Util qw[first];

binmode STDOUT, q(:utf8);
local $INPUT_RECORD_SEPARATOR = qq(\N{CARRIAGE RETURN});

my @header = (
    [ q(Data),         q(data), ],         #
    [ q(Histórico),    q(historico), ],    #
    [ q(Docto.),       q(documento), ],    #
    [ q(Crédito (R$)), q(credito), ],      #
    [ q(Débito (R$)),  q(debito), ],       #
    [ q(Saldo (R$)),   q(saldo), ],        #
);

my %extrato;
open my $fh, q(<), shift @ARGV;
while ( my $line = <$fh> ) {
    chomp $line;
    my @row = split /;/, $line;

    if ( $INPUT_LINE_NUMBER == 1 ) {
        if ([ split m{\s*[|]\s*}msx, $line ] ~~ [
                qr{\A^Extrato\sde:\sAg:\s\d\d\z}msx,
                qr{\AConta:\s\d+-\d\z}msx,
                qr{\AEntre\s\d\d/\d\d/\d{4}\se\s\d\d/\d\d/\d{4}\z}msx
            ]
            )
        {
            next;
        }
        else { die q(UNKNOWN FILE CONTENT); }
    }
    elsif ( $INPUT_LINE_NUMBER == 2 ) {
        my @h = map { $_->[0] } @header;
        @row ~~ @h ? next : die;
    }
    elsif ( @row > 3 && @row[ 0 .. 2 ] ~~ [ q(), q(Total), q() ] ) {
        last;
    }

    while ( my ( $i, $value ) = each @row ) {
        foreach ($value) {
            s{\p{IsSpace}+}{\N{SPACE}}gmsx;
            s{\A\N{SPACE}+}{}msx;
            s{\N{SPACE}+\z}{}msx;
            s{\A"}{}msx;
            s{"\z}{}msx;
        }

        if ( $i == 0 && $value =~ m{^(\d\d)/(\d\d)/(\d\d)$}msx ) {
            $value = join q(-), 2000 + $3,    #
                $2, $1;
        }
        elsif ( $i ~~ [ 3, 4, 5 ] && $value ne q() ) {
            if ($value =~                     #
                m{^(?<int>[+-]?[0-9]+(?:\.[0-9]{3})*)
                    (?:,(?<dec>[0-9]{2}))?$}msx
                )
            {
                my @num = @LAST_PAREN_MATCH{qw[int dec]};
                $num[0] =~ tr{.}{}d;
                $num[1] //= q(00);
                $value = join q(.), @num;
            }
        }
        $row[$i] = $value;
    } ## end while ( my ( $i, $value )...)

    if ( @row == 2 && $row[0] eq q() ) {
        my $idx = $INPUT_LINE_NUMBER - 1;
        $extrato{$idx}{detalhe} = $row[1];
    }
    else {
        my %row;
        $#row = $#header;
        @row{ map { $_->[1] } @header } = map { $_ // q() } @row;
        foreach (qw[credito debito saldo]) {
            next;
            next if $row{$_} eq q();
            my $value = $row{$_};
            $value = abs $value;
            $value = sprintf q(%.2f), $value;
            $value =~ tr{.}{,};
            $value =~ s/(?<=\d)(?=(?:\d{3})*\d{3}$)/./g;
            substr $value, 0, 0, q(R$);
            $row{$_} = $value;
        }

        %{ $extrato{$INPUT_LINE_NUMBER} } = %row;
    } ## end else [ if ( @row == 2 && $row...)]
} ## end while ( my $line = <$fh> )

my %ledger;
my @number = sort { $a <=> $b } keys %extrato;
for ( my $i = 0; $i <= $#number; $i++ ) {
    my %row = %{ $extrato{ $number[$i] } };

    say sprintf q(%s * %s), $row{data}, $row{historico};

    my $meta_payee;
    unless (
        first { lc $row{historico} eq $_ }
        ( q(rendimentos), q(saque cc autoat), q(dep c/c autoat) )
        )
    {
        if ( exists $row{detalhe} ) {
            $meta_payee = sprintf q(Payee: %s - %s),
                @row{qw[historico detalhe]};
        }
    }

    foreach (qw[detalhe documento]) {
        next unless exists $row{$_};
        next if $row{$_} eq q();
        next if $meta_payee && $_ eq q(detalhe);
        say sprintf q(    ;%s: %s), uc $_, $row{$_};
    }

    if ( $i == 0 ) {
        die if $row{historico} ne q(SALDO ANTERIOR);
        say sprintf q(    Assets:Cash:Bank    %s), $row{saldo};
        say q(    Equity:Opening);
    }
    elsif ( $row{debito} ne q() ) {
        my $expenses = sprintf q(    Expenses:Unknown    %s), $row{debito};
        if ($meta_payee) {
            $expenses .= q(    ;) . $meta_payee;
        }
        say $expenses;
        say q(    Assets:Cash:Bank);
    }
    elsif ( $row{credito} ne q() ) {
        my $income = sprintf q(    Income:Unknown    %s), $row{credito};
        if ($meta_payee) {
            $income .= q(    ;) . $meta_payee;
        }
        say $income;
        say q(    Assets:Cash:Bank);
    }
    else { die; }

} ## end for ( my $i = 0; $i <= ...)
