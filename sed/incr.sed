#!/usr/bin/sed

b und;

:dz;
s/\(^\|0\)+1/1/p;
s/1+1/2/p;
s/2+1/3/p;
s/3+1/4/p;
s/4+1/5/p;
s/5+1/6/p;
s/6+1/7/p;
s/7+1/8/p;
s/8+1/9/p;
s/9+1/+10/;
/+/ b dz;

:und;
s/0$/1/p;
s/1$/2/p;
s/2$/3/p;
s/3$/4/p;
s/4$/5/p;
s/5$/6/p;
s/6$/7/p;
s/7$/8/p;
s/8$/9/p;
s/9$/+10/;
b dz;
