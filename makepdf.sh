#!/bin/bash

export DISPLAY=:0
tty=$(fgconsole)
tty=1 # remendo
xtty=$(ps h -o tty -C X)

if [ ! -z "$1" ]; then
  /usr/share/texmf/bin/pdflatex $1
else
  exit 1
fi

if [ $? == 0 ]; then
  /usr/bin/sed -i '2s/.*/\\renewcommand\{\\l@section\}\{\\@dottedtocline\{1\}\{1\.5em\}\{2\.3em\}\}\n&/' ${1%.tex}.toc
  clear
#  tput cup $(expr $(tput lines) \/ 2) $(expr $(tput cols) \/ 2)
#  figlet OK \!
  sudo chvt ${xtty:3}
else
  exit 1
fi

if [ $? == 0 ]; then
  /usr/share/texmf/bin/pdflatex $1 2>&1>/dev/null
else
  exit 1
fi

if [ $? == 0 ]; then
  /usr/X11R6/bin/xpdf ${1%.tex}.pdf
  sudo chvt $tty
else
  exit 1
fi
