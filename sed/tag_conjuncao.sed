#!/usr/bin/sed -f

#==============================================================================
# Script para inserir tags <CONJ.> em conjuncoes
# Reference: http://pt.wikipedia.org/wiki/Conjun%C3%A7%C3%A3o
#
# Revision: 0.0.0
#==============================================================================


#==============================================================================
# Conjuncoes Essencias (palavras que funcionam exclusivamente como conjuncao)
#==============================================================================

s/\bapesar\b/<CONJ.>&</CONJ.>/Ig;
s/\bcomo\b/<CONJ.>&</CONJ.>/Ig;
s/\bcontudo\b/<CONJ.>&</CONJ.>/Ig;
s/\be\b/<CONJ.>&</CONJ.>/Ig;
s/\bentretanto\b/<CONJ.>&</CONJ.>/Ig;
s/\bmas\b/<CONJ.>&</CONJ.>/Ig;
s/\bnem\b/<CONJ.>&</CONJ.>/Ig;
s/\bora\b/<CONJ.>&</CONJ.>/Ig;
s/\bou\b/<CONJ.>&</CONJ.>/Ig;
s/\bpois\b/<CONJ.>&</CONJ.>/Ig;
s/\bporquanto\b/<CONJ.>&</CONJ.>/Ig;
s/\bporque\b/<CONJ.>&</CONJ.>/Ig;
s/\bportanto\b/<CONJ.>&</CONJ.>/Ig;
s/\bporém\b/<CONJ.>&</CONJ.>/Ig;
s/\bse\b/<CONJ.>&</CONJ.>/Ig;
s/\btodavia\b/<CONJ.>&</CONJ.>/Ig;
