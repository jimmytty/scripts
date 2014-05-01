#!/usr/bin/env perl

# Reference:
# $ man 6 phantasia

use common::sense;
use Getopt::Long;
use IPC::Open3;
use Symbol qw[gensym];
use Scalar::Util qw[looks_like_number];
use List::Util qw[first];
use YAML::XS;

my $opts;
my $result = GetOptions(
    q(number|#=i) => sub { $opts->{ $_[0] } = $_[1] },
    q(name|n=s)   => sub { $opts->{ $_[0] } = $_[1] },
    q(size|s=i)   => sub { $opts->{ $_[0] } = $_[1] },
);

sub monster_size {
    my ( $attribute, $initial_value, $size ) = splice @_;

    my $final_value;
    if ( $attribute eq q(Strength) ) {
        if ( $size > 1 ) { $final_value = $initial_value * $size * .5; }
    }
    elsif ( $attribute ~~ [qw[Energy_Level Experience Brains]] ) {
        $final_value = $initial_value * $size;
    }

    return $final_value;
}

my $system_cmd = q(/usr/games/phantasia);
my ( $wtr, $rdr, $err ) = map { gensym() } 1 .. 3;
my $pid = open3( $wtr, $rdr, $err, $system_cmd, q(-m) );
my $header = readline $rdr;
chomp $header;

my @header_map = (
    [ q|#)|, q(Number), ],
    [ q(Name), ],
    [ q(Str),    q(Strength), ],
    [ q(Brain),  q(Brains), ],
    [ q(Quick),  q(Quickness), ],
    [ q(Energy), q(Energy_Level), ],
    [ q(Exper),  q(Experience), ],
    [ q(Treas),  q(Treasure_Type), ],
    [ q(Type), ],
    [ q(Flock%), ],
);
my $hpack = q(A5A21A5A7A7A8A7A7A6A*);
my @header = unpack $hpack, $header;

foreach my $i ( 0 .. $#header ) {
    my $title = $header[$i];
    $title =~ s{\A\s+}{}msx;
    $title =~ s{\s+\z}{}msx;
    if ( $title eq $header_map[$i]->[0] ) {
        $title = $header_map[$i]->[1] if defined $header_map[$i]->[1];
        $header[$i] = $title;
    }
    else { die; }
}

my %special_ability = (
    q(Unicorn)          => q(yes),                 #
    q(Modnar)           => q(yes),                 #
    q(Mimic)            => q(yes),                 #
    q(Dark Lord)        => q(yes),                 #
    q(Leanan-Sidhe)     => q(yes),                 #
    q(Saruman)          => q(yes),                 #
    q(Thaumaturgist)    => q(yes),                 #
    q(Balrog)           => q(yes),                 #
    q(Vortex)           => q(yes),                 #
    q(Nazgul)           => q(yes),                 #
    q(Tiamat)           => q(yes),                 #
    q(Kobold)           => q(yes),                 #
    q(Shelob)           => q(yes),                 #
    q(Cluricaun)        => q(Assorted Faeries),    #
    q(Fir Darrig)       => q(Assorted Faeries),    #
    q(Fachan)           => q(Assorted Faeries),    #
    q(Ghille Dhu)       => q(Assorted Faeries),    #
    q(Bogle)            => q(Assorted Faeries),    #
    q(Killmoulis)       => q(Assorted Faeries),    #
    q(Bwca)             => q(Assorted Faeries),    #
    q(Assorted Faeries) => q(yes),                 #
    q(Lamprey)          => q(yes),                 #
    q(Shrieker)         => q(yes),                 #
    q(Bonnacon)         => q(yes),                 #
    q(Smeagol)          => q(yes),                 #
    q(Succubus)         => q(yes),                 #
    q(Cerberus)         => q(yes),                 #
    q(Ungoliant)        => q(yes),                 #
    q(Jabberwock)       => q(yes),                 #
    q(Morgoth)          => q(yes),                 #
    q(Troll)            => q(yes),                 #
    q(Wraith)           => q(yes),                 #
);
my %treasure_type = (
    0 => [ q(none), ],
    1 => [ q(power booster), q(druid), q(holy orb), ],
    2 => [ q(amulet), q(holy water), q(hermit), ],
    3 => [ q(shield), q(virgin), q(athelas), ],
    4 => [
        q(shield scroll),
        q(invisible scroll),
        q(ten fold strength scroll),
        q(pick monster scroll),
        q(general knowledge scroll),
    ],
    5  => [ q(dagger),         q(armour),      q(tablet), ],
    6  => [ q(priest),         q(Robin Hood),  q(axe), ],
    7  => [ q(charm),          q(Merlyn),      q(war hammer), ],
    8  => [ q(healing potion), q(transporter), q(sword), ],
    9  => [ q(crown),          q(blessing),    q(quicksilver), ],
    10 => [ q(elven boots), ],
    11 => [ q(palantir), ],
    12 => [ q(ring), ],
    13 => [ q(ring), ],
);
my ( %monster_index, @monster );
while ( my $line = readline $rdr ) {
    chomp $line;
    next if $line eq q();
    my @info = unpack $hpack, $line;
    my %info;
    foreach my $i ( 0 .. $#info ) {
        my $info = $info[$i];
        $info =~ s{\A\s+}{}msx;
        $info =~ s{\s+\z}{}msx;
        $info =~ tr{0-9}{}cd if $i == 0;

        $info += 0 if looks_like_number($info);

        if ( $i ~~ [ 0, 1 ] ) {
            if ( $i == 1 ) {
                my @wc_word = split m{\s+}msx, $info;
                if ( lc $wc_word[0] ~~ [qw[a an the]] ) {
                    shift @wc_word;
                }
                $info = join q( ), @wc_word;
            }
            $monster_index{ lc $info } = @monster;
        }
        elsif ( $header[$i] eq q(Treasure_Type) ) {
            $info = $treasure_type{$info};
        }
        $info{ $header[$i] } = $info;
        $info[$i] = { $header[$i] => $info };
    } ## end foreach my $i ( 0 .. $#info)

    push @info, { Size => exists $opts->{size} ? $opts->{size} : 1 };

    if ( exists $special_ability{ $info{Name} } ) {
        push @info, { Special_Ability => $special_ability{ $info{Name} } };
    }

    push @monster, [@info];
} ## end while ( my $line = readline...)

close $wtr;
close $rdr;
close $err;

my ( $key, $query );
if ( $key = first { exists $opts->{$_} and $opts->{$_} } qw[name number] ) {
    $query = lc $opts->{$key};
}

unless ( defined $query ) {
    say Dump @monster;
    exit;
}

my $index = $monster_index{$query};
die unless defined $index;

my $size;
my $monster = $monster[$index];
foreach my $info ( reverse @{$monster} ) {
    my $key   = ( keys %{$info} )[0];
    my $value = ( values %{$info} )[0];
    if ( $key eq q(Size) ) { $size = $value; next; }
    my $nv = monster_size( $key, $value, $size );
    $info = { $key => [ $value, $nv ] } if defined $nv;
}

say Dump $monster;
