#!/usr/bin/sed -f

### parcial...

:i;
$!N;
s/\n//;
ti;

$ {
  s/<br>/\n/Ig;
  s/<[^>]\+>//g;
}
