#!/bin/ash

usage () {
    local opt;

    opt=$(alias | while IFS=$' =' read cmd opt last; do echo -n $opt' | '; done)
    opt=${opt% | }
    cat <<EOF
Usage: `basename $0` < $opt >
EOF
    exit 1

    return 0;
}

alias       -h='SCREENS="$HOME/.screen/home"'
alias   --home='SCREENS="$HOME/.screen/home"'
alias       -o='SCREENS="$HOME/.screen/office"'
alias --office='SCREENS="$HOME/.screen/office"'

if alias $1 1>/dev/null 2>&1; then
    eval "$1"
else
    usage
fi

export SCREENS
export WDIR="$HOME/work"

/usr/bin/screen -wipe
/usr/bin/screen -maO
