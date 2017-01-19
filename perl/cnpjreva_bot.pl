#!/usr/bin/env perl

use common::sense;
use File::Basename;
use DDP;
use Time::Piece;
use File::Find;
use File::Basename;
use HTTP::Tiny;
use URI::URL;
use URI::QueryParam;
use WWW::Mechanize::Firefox;
use Business::BR::CNPJ;

use Parallel::ForkManager;
my $pm = Parallel::ForkManager->new(shift);

my $scheme    = q(http);
my $authority = q(www.receita.fazenda.gov.br);
my $website   = join q(://), $scheme, $authority;

my $uri = URI::URL->new($website);
$uri->path_segments(
    q(pessoajuridica),               #
    q(cnpj),                         #
    q(cnpjreva),                     #
    q(Cnpjreva_Solicitacao2.asp),    #
);

local $| = 1;
my $sep = q( => );

open my $outfh, q(+<), q(./captcha_breaked.txt);
open my $fh, q(<), q(./cnpj_list.txt) or die;

my %captcha = map { split $sep, s{\s*$}{}mrsx } readline $outfh;

my %dict;
foreach my $wavfile ( glob q(./test/?) ) {
    local $/ = undef;
    open my $rawfh, q(< :raw :bytes), $wavfile or die $!;
    my $wavdata = readline $rawfh;
    close $rawfh;
    my $char = fileparse( $wavfile, q(.wav) );
    $dict{$char}{data}   = $wavdata;
    $dict{$char}{length} = length $wavdata;
}

my $out_dir
    = q(./cnpj/www.receita.fazenda.gov.br/pessoajuridica/cnpj/cnpjreva/);
my %cnpj_next;
find sub {
    if ( $_ =~ m{(\d+)\.html$}msx ) { $cnpj_next{$1}++ }
}, $out_dir;

while ( my $cnpj = readline $fh ) {
    chomp $cnpj;

    next if exists $cnpj_next{$cnpj};

    my $pid = $pm->start() and next();

    my $file = $out_dir . $cnpj . q(.html);

    $uri->query_form_hash( { cnpj => $cnpj, } );

    my $mech = WWW::Mechanize::Firefox->new();

    $mech->get($uri);

    my $src = $mech->xpath(
        q{string(//img[@id='imgcaptcha']/@src)},    #
        single => 1,                                #
    );
    my $captcha = URI::URL->new($src);

    # <AUDIO>
    my $audio_uri = URI::URL->new($website);
    $audio_uri->path(q(scripts/captcha/Telerik.Web.UI.WebResource.axd));
    $audio_uri->query_form_hash(
        {   type => q(cah),
            guid => $captcha->query_param(q(guid)),
        }
    );
    my $http_tiny = HTTP::Tiny->new->get( $audio_uri->as_string() );
    unless ( $http_tiny->{success} ) {
        say sprintf q(ERROR => %s), $audio_uri->as_string();
        die;
    }
    my $audio = $http_tiny->{content};

    # </AUDIO>

    say $cnpj;
    my $input;

    #------------------------------------------
    my @parser;
    my @charname = reverse sort { $dict{$a}{length} <=> $dict{$b}{length} }
        keys %dict;

    my $i   = 6;
    my $wav = $audio;
    while ( $i-- ) {
        my %parser;
        foreach my $charname (@charname) {
            my $data = $dict{$charname}{data};
            my $index = index $wav, $data;
            if ( $index != -1 ) { $parser{$index}{$charname}++; }
        }

        if (%parser) {
            my $index_ini = ( sort { $a <=> $b } keys %parser )[0];
            my $char = ( keys %{ $parser{$index_ini} } )[0];
            substr $wav, 0, $index_ini, q();
            substr $wav, 0, $dict{$char}{length}, q();
            push @parser, $char;
        }

        #else { @parser = (); }
    } ## end while ( $i-- )
    my $parser = join q(), @parser;

    #------------------------------------------

    if ($parser) {
        $input = $parser;
        say q(AUDIO BREAKED (?));
    }
    elsif ( exists $captcha{ $captcha->query() } ) {
        say q(Getting captcha from file);
        say join $sep, $captcha->query(), $input;
        $input = $captcha{ $captcha->query() };
    }
    else { print q(> ); $input = readline STDIN; chomp $input; }

    if ( $input eq q(q) ) { last; }

    my $form_id = q(theForm);
    $mech->form_id($form_id);
    $mech->field( captcha => $input );
    $mech->click(q(submit1));

    if ( $mech->base() eq
        q(http://www.receita.fazenda.gov.br/pessoajuridica/cnpj/cnpjreva/Cnpjreva_Comprovante.asp)
        )
    {
        my $record = join $sep, $captcha->query(), $input;
        say $outfh $record;
        $mech->save_content($file);
        say $file;

        # say $file;

        # # <AUDIO>
        # my $filename = q(./captcha/audio);
        # $filename = sprintf(
        #     q(%s/%s&captcha=%s),    #
        #     $filename,              #
        #     $audio_uri->query(),    #
        #     $input,                 #
        # );
        # my $encoding = q(:raw :bytes);
        # open my $afh, qq(> $encoding), $filename or die $!;
        # print $afh $audio;
        # close $afh;

        # # </AUDIO>
    } ## end if ( $mech->base() eq ...)
    else { say $mech->base(); }

    $pm->finish();

} ## end while ( my $cnpj = readline...)
