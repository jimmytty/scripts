#!/usr/bin/bc -lq
# /bin/env BC_LINE_LENGTH=0 bc fatorial.b

x = read();
for ( i = x - 1; i >= 1; i-- ){
  x *= i;
}
#print x,"\n";
x;

quit;
