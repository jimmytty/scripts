#!/usr/bin/sed -f

#=============================================================================
# sed-script para testar o script arabico2romano.sed
#=============================================================================

b main;

: fail;
s/.*/test & .. fail\nabort/;
q 1;

: main;

# teste 1
s/.*/1/;
x;
s%.*%seq -4000 10000 | ../arabico2romano.sed | sed '$=;d'%e;
/^3999$/ ! {
  x;
  b fail;
}
x;
s/.*/test & .. ok/p;

# teste 2
s/.*/2/;
x;
s%.*%../arabico2romano.sed <<< 1001%e;
/^MI$/ ! {
   x;
   b fail;
}
x;
s/.*/test & .. ok/p;

# teste 3
s/.*/3/;
x;
s%.*%../arabico2romano.sed <<< 2754%e;
/^MMDCCLIV$/ ! {
   x;
   b fail;
}
x;
s/.*/test & .. ok/p;

# teste 4
s/.*/4/;
x;
s%.*%../arabico2romano.sed <<< 3999%e;
/^MMMCMXCIX$/ ! {
   x;
   b fail;
}
x;
s/.*/test & .. ok/;

