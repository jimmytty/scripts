#!/usr/bin/sed -f

### apenas teste

#h;

# 1. Transformar em mai�sculas todas as letras da palavra a ser codificada;
y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/;
y/���������������������������/���������������������������/

# 2. Eliminar todos os acentos das vogais;
s/[������]/A/g;
s/[����]/E/g;
s/[����]/I/g;
s/[�����]/O/g;
s/[����]/U/g;
s/�/Y/g;

# 3. Substituir as letras conforme tabela (...);
s/BL\|BR/B/g;
s/CA/K/g;
s/L/R/g;
s/RM/SM/g;
s/N\|MD/M/g;
s/RJ/J/g;
s/CE\|CI/S/g;
s/MG/G/g;
s/ST\|TR\|TL/T/g;
s/CO\|CU\|CK/K/g;
s/MJ/J/g;
s/TS/S/g;
s/�\|CH/S/g;
s/PH/F/g;
s/W/V/g;
s/CT/T/g;
s/PR/P/g;
s/X/S/g;
s/GE\|GI/J/g;
s/Q/K/g;
s/ST/T/g;
s/GM/M/g;
s/RG/G/g;
s/Y/I/g;
s/GL\|GR/G/g;
s/RS/S/g;
s/Y/I/g;
s/RT/T/g;
s/CS/S/g;
s/Z/S/g;

# 4. Eliminar os M, R e S no final de palavras;
s/[MRS]\b//g;

# 5. Eliminar todas as vogais e mais o H;
s/[AEIOUH]//g;

# 6. Elimniar caracteres repetidos;
/.../ {
  s/\([^\b]\)\1/\1/g;
}

# 7. repescagem;
s/\([^\b]\)MD\b/\1M/;
s/\([^\b]\)TV\b/\1T/;
s/\([^\b]\)RJ/\1J/;
s/\([^\b]\)RS/\1S/;

# out
#G;
#s/\([^\n]\+\)\n\(.*\)/\2 -> \1/

