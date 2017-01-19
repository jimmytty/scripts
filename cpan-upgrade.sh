#!/bin/bash

. $HOME/.profile

minicpan -qq -f -d 0775

( /usr/bin/gawk '
  FILENAME == ARGV[1] {
      gsub("^authors/id/", "", $0);
      mpath[$0]++;
  }
  FILENAME == ARGV[2] {
      mname[$3] = $1;
  }
  END {
      for ( m in mpath ) {
         if ( m in mname ) print mname[m];
      }
  }' <(find $CPAN_MINI -type f -regex '^.*/id/.*$' -newermt `date -d'2 years ago' +%F` -not -name 'CHECKSUMS'|sed 's|'$CPAN_MINI'/\?||') <(zcat $CPAN_MINI/modules/02packages.details.txt.gz)
  cpan-outdated -p --mirror file://$CPAN_MINI
) |
/usr/bin/sort --unique |
/usr/bin/shuf |
/usr/bin/xargs   \
    --max-args=3  \
    --max-procs=3 \
    --max-lines=1 \
    /usr/bin/timeout 10m \
    cpanm \
        --mirror $CPAN_MINI \
        --mirror-only \
        --prompt \
        --skip-installed \
        --auto-cleanup 1 \
        --quiet

/usr/bin/rm --force --recursive $HOME/.cpanm/work/
/usr/bin/mkdir $HOME/.cpanm/work/
