#!/bin/sh

case $1 in
    -h|--home)   SCREENS="$HOME/.screen/home"   ;;
    -o|--office) SCREENS="$HOME/.screen/office" ;;
    *) echo -e 'Usage: '`basename $0`' < -h | --home | -o | --office >'; exit 1;;
esac

export SCREENS
export WDIR="$HOME/work"

/usr/bin/screen -wipe
/usr/bin/screen -maO
