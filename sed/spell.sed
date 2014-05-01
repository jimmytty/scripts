#!/usr/bin/sed -f

# automatiza algumas verifica��es de texto

/\t/ s//& <tabula��es>/p;
/\s$/ s//& <espa�os no final de linha>/p;
/^[= ]\+/ {
     /^=.*\.$/ s//& <t�tulo terminado em ponto>/p;
     d;
}
#/[^,;!.:?]$/ s//& <par�grafo sem pontua��o terminal>/p;
/\s[,;!.:?]$/ s//& <espa�amento entre palavra e pontua��o>/p;
/\S\s\s+\S/ s//& <excesso de espa�os>/p;
d;
