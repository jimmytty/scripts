#!/bin/sh

DATE="`/bin/date +%F`"
BKPDIR='var/spool/backup'
TARFILE="$HOME/$BKPDIR/bkp_$DATE.tar.bz2"
BKPCONF="$HOME/.bkp.conf"

while /usr/bin/git status --short --untracked-files=no |
      /usr/bin/grep -q '^ \+[ACDMRU]'; do
    (cd; /usr/bin/tig status)
done

if [ ! -s $TARFILE ]; then
    /usr/bin/crontab -l > "$HOME/.crontab"
    /bin/nice --adjustment=19 \
    /usr/bin/tar \
        --absolute-names \
        --block-number \
        --bzip2 \
        --create \
        --exclude-backups \
        --exclude-backups \
        --exclude=$HOME/.elinks/socket0 \
        --exclude='*~' \
        --file $TARFILE \
        --files-from $BKPCONF \
        --ignore-failed-read \
        --preserve-order \
        --preserve-permissions \
        --totals \
        --verbose
fi

/bin/nice --adjustment=19 \
/usr/bin/tar -tf $TARFILE || /bin/rm $TARFILE
