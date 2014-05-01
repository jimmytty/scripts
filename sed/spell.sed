#!/usr/bin/sed -f

# automatiza algumas verificações de texto

/\t/ s//& <tabulações>/p;
/\s$/ s//& <espaços no final de linha>/p;
/^[= ]\+/ {
     /^=.*\.$/ s//& <título terminado em ponto>/p;
     d;
}
#/[^,;!.:?]$/ s//& <parágrafo sem pontuação terminal>/p;
/\s[,;!.:?]$/ s//& <espaçamento entre palavra e pontuação>/p;
/\S\s\s+\S/ s//& <excesso de espaços>/p;
d;
