#!/usr/bin/sed -f

### reference: http://www.w3schools.com/tags/ref_ascii.asp

### ASCII Printable Characters
s/&#32;/ /g;   # space
s/&#33;/!/g;   # exclamation mark
s/&#34;/"/g;   # quotation mark
s/&#35;/#/g;   # number sign
s/&#36;/$/g;   # dollar sign
s/&#37;/%/g;   # percent sign
s/&#38;/\&/g;  # ampersand
s/&#39;/'/g;   # apostrophe
s/&#40;/(/g;   # left parenthesis
s/&#41;/)/g;   # right parenthesis
s/&#42;/*/g;   # asterisk
s/&#43;/+/g;   # plus sign
s/&#44;/,/g;   # comma
s/&#45;/-/g;   # hyphen
s/&#46;/./g;   # period
s/&#47;/\//g;  # slash
s/&#48;/0/g;   # digit 0
s/&#49;/1/g;   # digit 1
s/&#50;/2/g;   # digit 2
s/&#51;/3/g;   # digit 3
s/&#52;/4/g;   # digit 4
s/&#53;/5/g;   # digit 5
s/&#54;/6/g;   # digit 6
s/&#55;/7/g;   # digit 7
s/&#56;/8/g;   # digit 8
s/&#57;/9/g;   # digit 9
s/&#58;/:/g;   # colon
s/&#59;/;/g;   # semicolon
s/&#60;/</g;   # less-than
s/&#61;/=/g;   # equals-to
s/&#62;/>/g;   # greater-than
s/&#63;/?/g;   # question mark
s/&#64;/@/g;   # at sign
s/&#65;/A/g;   # uppercase A
s/&#66;/B/g;   # uppercase B
s/&#67;/C/g;   # uppercase C
s/&#68;/D/g;   # uppercase D
s/&#69;/E/g;   # uppercase E
s/&#70;/F/g;   # uppercase F
s/&#71;/G/g;   # uppercase G
s/&#72;/H/g;   # uppercase H
s/&#73;/I/g;   # uppercase I
s/&#74;/J/g;   # uppercase J
s/&#75;/K/g;   # uppercase K
s/&#76;/L/g;   # uppercase L
s/&#77;/M/g;   # uppercase M
s/&#78;/N/g;   # uppercase N
s/&#79;/O/g;   # uppercase O
s/&#80;/P/g;   # uppercase P
s/&#81;/Q/g;   # uppercase Q
s/&#82;/R/g;   # uppercase R
s/&#83;/S/g;   # uppercase S
s/&#84;/T/g;   # uppercase T
s/&#85;/U/g;   # uppercase U
s/&#86;/V/g;   # uppercase V
s/&#87;/W/g;   # uppercase W
s/&#88;/X/g;   # uppercase X
s/&#89;/Y/g;   # uppercase Y
s/&#90;/Z/g;   # uppercase Z
s/&#91;/[/g;   # left square bracket
s/&#92;/\\/g;  # backslash
s/&#93;/]/g;   # right square bracket
s/&#94;/^/g;   # caret
s/&#95;/_/g;   # underscore
s/&#96;/`/g;   # grave accent
s/&#97;/a/g;   # lowercase a
s/&#98;/b/g;   # lowercase b
s/&#99;/c/g;   # lowercase c
s/&#100;/d/g;  # lowercase d
s/&#101;/e/g;  # lowercase e
s/&#102;/f/g;  # lowercase f
s/&#103;/g/g;  # lowercase g
s/&#104;/h/g;  # lowercase h
s/&#105;/i/g;  # lowercase i
s/&#106;/j/g;  # lowercase j
s/&#107;/k/g;  # lowercase k
s/&#108;/l/g;  # lowercase l
s/&#109;/m/g;  # lowercase m
s/&#110;/n/g;  # lowercase n
s/&#111;/o/g;  # lowercase o
s/&#112;/p/g;  # lowercase p
s/&#113;/q/g;  # lowercase q
s/&#114;/r/g;  # lowercase r
s/&#115;/s/g;  # lowercase s
s/&#116;/t/g;  # lowercase t
s/&#117;/u/g;  # lowercase u
s/&#118;/v/g;  # lowercase v
s/&#119;/w/g;  # lowercase w
s/&#120;/x/g;  # lowercase x
s/&#121;/y/g;  # lowercase y
s/&#122;/z/g;  # lowercase z
s/&#123;/{/g;  # left curly brace
s/&#124;/|/g;  # vertical bar
s/&#125;/}/g;  # right curly brace
s/&#126;/~/g;  # tilde

### ASCII Device Control Characters
s/&#00;/\d00/g;    # (NUL) null character
s/&#01;/\d01/g;    # (SOH) start of header
s/&#02;/\d02/g;    # (STX) start of text
s/&#03;/\d03/g;    # (ETX) end of text
s/&#04;/\d04/g;    # (EOT) end of transmission
s/&#05;/\d05/g;    # (ENQ) enquiry
s/&#06;/\d06/g;    # (ACK) acknowledge
s/&#07;/\d07/g;    # (BEL) bell (ring)
s/&#08;/\d08/g;    # (BS) backspace
s/&#09;/\d09/g;    # (HT) horizontal tab
s/&#10;/\d10/g;    # (LF) line feed
s/&#11;/\d11/g;    # (VT) vertical tab
s/&#12;/\d12/g;    # (FF) form feed
s/&#13;/\d13/g;    # (CR) carriage return
s/&#14;/\d14/g;    # (SO) shift out
s/&#15;/\d15/g;    # (SI) shift in
s/&#16;/\d16/g;    # (DLE) data link escape
s/&#17;/\d17/g;    # (DC1) device control 1
s/&#18;/\d18/g;    # (DC2) device control 2
s/&#19;/\d19/g;    # (DC3) device control 3
s/&#20;/\d20/g;    # (DC4) device control 4
s/&#21;/\d21/g;    # (NAK) negative acknowledge
s/&#22;/\d22/g;    # (SYN) synchronize
s/&#23;/\d23/g;    # (ETB) end transmission block
s/&#24;/\d24/g;    # (CAN) cancel
s/&#25;/\d25/g;    # (EM) end of medium
s/&#26;/\d26/g;    # (SUB) substitute
s/&#27;/\d27/g;    # (ESC) escape
s/&#28;/\d28/g;    # (FS) file separator
s/&#29;/\d29/g;    # (GS) group separator
s/&#30;/\d30/g;    # (RS) record separator
s/&#31;/\d31/g;    # (US) unit separator
s/&#127;/\d127/g;  # (DEL) delete (rubout)



### reference http://www.w3schools.com/tags/ref_entities.asp

# Reserved Characters in HTML
s/&#34;\|&quot;/"/g;  # quotation mark
s/&#39;\|&apos;/'/g;  # apostrophe
s/&#38;\|&amp;/\&/g;  # ampersand
s/&#60;\|&lt;/</g;    # less-than
s/&#62;\|&gt;/>/g;    # greater-than

# ISO 8859-1 Symbols
s/&#160;\|&nbsp;/ /g;     # non-breaking space
s/&#161;\|&iexcl;/¡/g;    # inverted exclamation mark
s/&#162;\|&cent;/¢/g;     # cent
s/&#163;\|&pound;/£/g;    # pound
s/&#164;\|&curren;/¤/g;   # currency
s/&#165;\|&yen;/¥/g;      # yen
s/&#166;\|&brvbar;/¦/g;   # broken vertical bar
s/&#167;\|&sect;/§/g;     # section
s/&#168;\|&uml;/¨/g;      # spacing diaeresis
s/&#169;\|&copy;/©/g;     # copyright
s/&#170;\|&ordf;/ª/g;     # feminine ordinal indicator
s/&#171;\|&laquo;/«/g;    # angle quotation mark
s/&#172;\|&not;/¬/g;      # negation
s/&#173;\|&shy;/\o173/g;  # soft hyphen
s/&#174;\|&reg;/®/g;      # registered trademark
s/&#175;\|&macr;/¯/g;     # spacing macron
s/&#176;\|&deg;/°/g;      # degree
s/&#177;\|&plusmn;/±/g;   # plus-or-minus
s/&#178;\|&sup2;/²/g;     # superscript 2
s/&#179;\|&sup3;/³/g;     # superscript 3
s/&#180;\|&acute;/´/g;    # spacing acute
s/&#181;\|&micro;/µ/g;    # micro
s/&#182;\|&para;/¶/g;     # paragraph
s/&#183;\|&middot;/·/g;   # middle dot
s/&#184;\|&cedil;/¸/g;    # spacing cedilla
s/&#185;\|&sup1;/¹/g;     # superscript 1
s/&#186;\|&ordm;/º/g;     # masculine ordinal indicator
s/&#187;\|&raquo;/»/g;    # angle quotation mark
s/&#188;\|&frac14;/¼/g;   # fraction 1/4
s/&#189;\|&frac12;/½/g;   # fraction 1/2
s/&#190;\|&frac34;/¾/g;   # fraction 3/4
s/&#191;\|&iquest;/¿/g;   # inverted question mark
s/&#215;\|&times;/×/g;    # multiplication
s/&#247;\|&divide;/÷/g;   # division

# ISO 8859-1 Characters
s/&#192;\|&Agrave;/À/g;  # capital a, grave
s/&#193;\|&Aacute;/Á/g;  # capital a, acute
s/&#194;\|&Acirc;/Â/g;   # capital a, circumflex
s/&#195;\|&Atilde;/Ã/g;  # capital a, tilde
s/&#196;\|&Auml;/Ä/g;    # capital a, umlaut
s/&#197;\|&Aring;/Å/g;   # capital a, ring
s/&#198;\|&AElig;/Æ/g;   # capital ae
s/&#199;\|&Ccedil;/Ç/g;  # capital c, cedilla
s/&#200;\|&Egrave;/È/g;  # capital e, grave
s/&#201;\|&Eacute;/É/g;  # capital e, acute
s/&#202;\|&Ecirc;/Ê/g;   # capital e, circumflex
s/&#203;\|&Euml;/Ë/g;    # capital e, umlaut
s/&#204;\|&Igrave;/Ì/g;  # capital i, grave
s/&#205;\|&Iacute;/Í/g;  # capital i, acute
s/&#206;\|&Icirc;/Î/g;   # capital i, circumflex
s/&#207;\|&Iuml;/Ï/g;    # capital i, umlaut
s/&#208;\|&ETH;/Ð/g;     # capital eth, Icelandic
s/&#209;\|&Ntilde;/Ñ/g;  # capital n, tilde
s/&#210;\|&Ograve;/Ò/g;  # capital o, grave
s/&#211;\|&Oacute;/Ó/g;  # capital o, acute
s/&#212;\|&Ocirc;/Ô/g;   # capital o, circumflex
s/&#213;\|&Otilde;/Õ/g;  # capital o, tilde
s/&#214;\|&Ouml;/Ö/g;    # capital o, umlaut
s/&#216;\|&Oslash;/Ø/g;  # capital o, slash
s/&#217;\|&Ugrave;/Ù/g;  # capital u, grave
s/&#218;\|&Uacute;/Ú/g;  # capital u, acute
s/&#219;\|&Ucirc;/Û/g;   # capital u, circumflex
s/&#220;\|&Uuml;/Ü/g;    # capital u, umlaut
s/&#221;\|&Yacute;/Ý/g;  # capital y, acute
s/&#222;\|&THORN;/Þ/g;   # capital THORN, Icelandic
s/&#223;\|&szlig;/ß/g;   # small sharp s,
s/&#224;\|&agrave;/à/g;  # small a, grave
s/&#225;\|&aacute;/á/g;  # small a, acute
s/&#226;\|&acirc;/â/g;   # small a, circumflex
s/&#227;\|&atilde;/ã/g;  # small a, tilde
s/&#228;\|&auml;/ä/g;    # small a, umlaut
s/&#229;\|&aring;/å/g;   # small a, ring
s/&#230;\|&aelig;/æ/g;   # small ae
s/&#231;\|&ccedil;/ç/g;  # small c, cedilla
s/&#232;\|&egrave;/è/g;  # small e, grave
s/&#233;\|&eacute;/é/g;  # small e, acute
s/&#234;\|&ecirc;/ê/g;   # small e, circumflex
s/&#235;\|&euml;/ë/g;    # small e, umlaut
s/&#236;\|&igrave;/ì/g;  # small i, grave
s/&#237;\|&iacute;/í/g;  # small i, acute
s/&#238;\|&icirc;/î/g;   # small i, circumflex
s/&#239;\|&iuml;/ï/g;    # small i, umlaut
s/&#240;\|&eth;/ð/g;     # small eth, Icelandic
s/&#241;\|&ntilde;/ñ/g;  # small n, tilde
s/&#242;\|&ograve;/ò/g;  # small o, grave
s/&#243;\|&oacute;/ó/g;  # small o, acute
s/&#244;\|&ocirc;/ô/g;   # small o, circumflex
s/&#245;\|&otilde;/õ/g;  # small o, tilde
s/&#246;\|&ouml;/ö/g;    # small o, umlaut
s/&#248;\|&oslash;/ø/g;  # small o, slash
s/&#249;\|&ugrave;/ù/g;  # small u, grave
s/&#250;\|&uacute;/ú/g;  # small u, acute
s/&#251;\|&ucirc;/û/g;   # small u, circumflex
s/&#252;\|&uuml;/ü/g;    # small u, umlaut
s/&#253;\|&yacute;/ý/g;  # small y, acute
s/&#254;\|&thorn;/þ/g;   # small thorn, Icelandic
s/&#255;\|&yuml;/ÿ/g;    # small y, umlaut

