#!/usr/bin/sed -f

# tenta facilitar a leitura de arquivos tex acentuados convertidos para pdf.


# testar a primeira linha
1 {
  /[^\w0-9]/ d;
}
:begin;
N;

# marcar todos os acentos com tags
s/[\xB4\xB8\x60~^]/<PUNCT>/g;
# remover espacos em branco entre os acentos
s/[ \t]\+\(<PUNCT>\)/\1/g;
s/\(<PUNCT>\)[ \t]\+/\1/g;
# resumir os acentos na mesma que estiverem na mesma linha
s/\(<PUNCT>\)\+/\1/g;
# remover linhas formadas apenas de acentos
s/\n<PUNCT>\n/\n/g;

#problema com o "i" acentuado
# primeiro marcar e remover os "i" perdidos
s/\n[ \t]\+i\(\s\)/\n<I-lost>\1/g;
s/\(<I-lost>\)[ \t]\+/\1/g;
# colocando o "i" dentro da palavra
s/\([A-Za-z]\)<PUNCT>/\1i/g; 
s/<PUNCT>\([A-Za-z]\)/i\1/g;

# remocao das linhas formadas por "i" perdido e/ou acento 
s/\n\(<I-lost>\|<PUNCT>\)\n/\n/g;

# concatenar linhas que comecam com "i" perdido e/ou acento
# que continuam o texto
s/\n\(<I-lost>\|<PUNCT>\)\([^\n]\)/\2/g;

# linhas que comecam com espacos antecedidas por acentos
s/\([A-Z0-9[:punct:]]\)<PUNCT>\n[ \t]\+/\1 /g;

# limpeza do <PUNCT>
s/<PUNCT>\n/\n/g;
b begin;

