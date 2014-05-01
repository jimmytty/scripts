#!/usr/bin/sed

/^procmail:\s\[[0-9]\+\]\s\w\+\s/ {
 s///;
 :oo;
 N;
 s/\nprocmail:[^\n]\+//;
 t oo;
};

s/\n//;
s/^\s\+//;
/[0-9]\sSubject:/!d