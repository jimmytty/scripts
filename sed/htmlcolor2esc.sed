#!/usr/bin/sed -f

### experimental

s/color="#8080ff">/&\o33[40;34m/gI;   # bold blue
s/color="#00ffff">/&\o33[40;36;1m/gI; # cyan
s/color="#ffff00">/&\o33[40;33m/gI;   # yellow
s/color="#ff6060">/&\o33[40;31m/gI;   # red
s/color="#ff40ff">/&\o33[40;35m/gI;   # magenta


s|</font>|\o33[0m|gI; # reset color
