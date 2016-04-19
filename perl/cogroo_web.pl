#!/usr/bin/env perl

=pod

=encoding utf8

A motivação deste I<script> é a triste realidade B<Java> do projeto B<CoGrOO - Corretor Gramatical acoplável ao LibreOffice> (L<http://cogroo.org/>).

Versão Experimental.

=cut

use common::sense;
use autodie;
use warnings q(all);

use YAML::XS ();
use HTML::TreeBuilder::LibXML;
use WWW::Mechanize;

sub parse {
    my $html = shift;

    my $tree = HTML::TreeBuilder::LibXML->new();
    $tree->parse($html);

    my %parse;

    foreach my $table_id (qw[table_morf table_err]) {
        my $table_xpath = sprintf q{//table[@id="%s"]}, $table_id;
        my $table_node = $tree->findnodes($table_xpath)->[0];
        next unless $table_node;
        my @th = $table_node->findnodes(q{thead/tr/th});
        my @header;
        while ( my ( $i, $th ) = each @th ) {
            my $label = $th->findvalue(q{normalize-space(string(.))});
            push @header, $label;
        }
        my @tr = $table_node->findnodes(q{tbody/tr});
        while ( my ( $tr_i, $tr ) = each @tr ) {
            my @tr;
            my @td = $tr->findnodes(q{td});
            while ( my ( $td_i, $td ) = each @td ) {
                my $label = $header[$td_i];
                my $value = $td->findvalue(q{normalize-space(string(.))});
                push @tr, { $label, $value };
            }
            my $id = $table_id =~ s/^table_//r;
            push @{ $parse{$table_id} }, [@tr];
        }
    } ## end foreach my $table_id (qw[table_morf table_err])

    foreach ( $parse{err} ) {
        last if $_;
        if (my $err = $tree->findnodes(
                q{
            //p[preceding-sibling::h3[
                  normalize-space(string(.))='Erros gramaticais'
               ]]}
            )->[0]
            )
        {
            $_ = $err->findvalue(q{normalize-space(string(.))});
        }
    }

    return %parse;
} ## end sub parse

my $mech = WWW::Mechanize->new(
    autocheck => 0,
    noproxy   => 1,
);
$mech->timeout(30);

$mech->agent_alias(q(Linux Mozilla));
my @sentence = grep { $_ ne q() } split /(?<=[.!?])\s+(?=\p{Lu})|\n/, <>;

foreach my $sentence (@sentence) {
    if ( length $sentence > 255 ) {
        say q([INFO] A sentença:);
        say sprintf q("%s"), $sentence;
        say q([INFO] É superior a 255 caracteres e);
        say q([INFO] seria truncada.);
        say q([INFO] Insira quebras manuais e tente novamente);
        say q([INFO] (abortando...));
        exit;
    }
}

exit unless @sentence;

$mech->get(q(http://comunidade.cogroo.org/grammar));

while ( my $sentence = shift @sentence ) {
    chomp $sentence;
    say sprintf q([SENTENÇA] '%s':), $sentence;

    my %form = ( text => $sentence, );
    $mech->form_number(2);
    while ( my ( $key, $value ) = each %form ) {
        $mech->field( $key => $value );
    }
    $mech->submit();

    my %parse = parse( $mech->content() );
    unless (%parse) {
        say q([ERROR] NAO CONSEGUI RESPOSTA.);
        next;
    }
    say YAML::XS::Dump( $parse{err} );
} ## end while ( my $sentence = shift...)
