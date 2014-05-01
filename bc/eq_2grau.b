#!/usr/bin/bc -lq

a = read();
b = read();
c = read();

print a, "x² + ", b,"x + ", c, " = 0 \n";

delta = b ^ 2 - ( 4 * a * c );

x1 = ( - (b) + sqrt(delta) ) / 2 * a;
x2 = ( - (b) - sqrt(delta) ) / 2 * a;

print "x'  = ", x1, "\n";
print "x'' = ", x2, "\n";

quit;