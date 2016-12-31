#!/usr/bin/sed -f

### inserir referências e testar

s/^/\n/;

:main
### ASCII Printable Characters
s/\n /\&#32;\n/;	# space 
s/\n!/\&#33;\n/;	# exclamation mark
s/\n"/\&#34;\n/;	# quotation mark
s/\n#/\&#35;\n/;	# number sign
s/\n\$/\&#36;\n/;	# dollar sign
s/\n%/\&#37;\n/;	# percent sign
s/\n&/\&#38;\n/;	# ampersand
s/\n'/\&#39;\n/;	# apostrophe
s/\n(/\&#40;\n/;	# left parenthesis
s/\n)/\&#41;\n/;	# right parenthesis
s/\n\*/\&#42;\n/;	# asterisk
s/\n+/\&#43;\n/;	# plus sign
s/\n,/\&#44;\n/;	# comma
s/\n-/\&#45;\n/;	# hyphen
s/\n\./\&#46;\n/;	# period
s/\n\//\&#47;\n/;	# slash
s/\n0/\&#48;\n/;	# digit 0
s/\n1/\&#49;\n/;	# digit 1
s/\n2/\&#50;\n/;	# digit 2
s/\n3/\&#51;\n/;	# digit 3
s/\n4/\&#52;\n/;	# digit 4
s/\n5/\&#53;\n/;	# digit 5
s/\n6/\&#54;\n/;	# digit 6
s/\n7/\&#55;\n/;	# digit 7
s/\n8/\&#56;\n/;	# digit 8
s/\n9/\&#57;\n/;	# digit 9
s/\n:/\&#58;\n/;	# colon
s/\n;/\&#59;\n/;	# semicolon
s/\n</\&#60;\n/;	# less-than
s/\n=/\&#61;\n/;	# equals-to
s/\n>/\&#62;\n/;	# greater-than
s/\n?/\&#63;\n/;	# question mark
s/\n@/\&#64;\n/;	# at sign
s/\nA/\&#65;\n/;	# uppercase A
s/\nB/\&#66;\n/;	# uppercase B
s/\nC/\&#67;\n/;	# uppercase C
s/\nD/\&#68;\n/;	# uppercase D
s/\nE/\&#69;\n/;	# uppercase E
s/\nF/\&#70;\n/;	# uppercase F
s/\nG/\&#71;\n/;	# uppercase G
s/\nH/\&#72;\n/;	# uppercase H
s/\nI/\&#73;\n/;	# uppercase I
s/\nJ/\&#74;\n/;	# uppercase J
s/\nK/\&#75;\n/;	# uppercase K
s/\nL/\&#76;\n/;	# uppercase L
s/\nM/\&#77;\n/;	# uppercase M
s/\nN/\&#78;\n/;	# uppercase N
s/\nO/\&#79;\n/;	# uppercase O
s/\nP/\&#80;\n/;	# uppercase P
s/\nQ/\&#81;\n/;	# uppercase Q
s/\nR/\&#82;\n/;	# uppercase R
s/\nS/\&#83;\n/;	# uppercase S
s/\nT/\&#84;\n/;	# uppercase T
s/\nU/\&#85;\n/;	# uppercase U
s/\nV/\&#86;\n/;	# uppercase V
s/\nW/\&#87;\n/;	# uppercase W
s/\nX/\&#88;\n/;	# uppercase X
s/\nY/\&#89;\n/;	# uppercase Y
s/\nZ/\&#90;\n/;	# uppercase Z
s/\n\[/\&#91;\n/;	# left square bracket
s/\n\\/\&#92;\n/;	# backslash
s/\n]/\&#93;\n/;	# right square bracket
s/\n\^/\&#94;\n/;	# caret
s/\n_/\&#95;\n/;	# underscore
s/\n`/\&#96;\n/;	# grave accent
s/\na/\&#97;\n/;	# lowercase a
s/\nb/\&#98;\n/;	# lowercase b
s/\nc/\&#99;\n/;	# lowercase c
s/\nd/\&#100;\n/;	# lowercase d
s/\ne/\&#101;\n/;	# lowercase e
s/\nf/\&#102;\n/;	# lowercase f
s/\ng/\&#103;\n/;	# lowercase g
s/\nh/\&#104;\n/;	# lowercase h
s/\ni/\&#105;\n/;	# lowercase i
s/\nj/\&#106;\n/;	# lowercase j
s/\nk/\&#107;\n/;	# lowercase k
s/\nl/\&#108;\n/;	# lowercase l
s/\nm/\&#109;\n/;	# lowercase m
s/\nn/\&#110;\n/;	# lowercase n
s/\no/\&#111;\n/;	# lowercase o
s/\np/\&#112;\n/;	# lowercase p
s/\nq/\&#113;\n/;	# lowercase q
s/\nr/\&#114;\n/;	# lowercase r
s/\ns/\&#115;\n/;	# lowercase s
s/\nt/\&#116;\n/;	# lowercase t
s/\nu/\&#117;\n/;	# lowercase u
s/\nv/\&#118;\n/;	# lowercase v
s/\nw/\&#119;\n/;	# lowercase w
s/\nx/\&#120;\n/;	# lowercase x
s/\ny/\&#121;\n/;	# lowercase y
s/\nz/\&#122;\n/;	# lowercase z
s/\n{/\&#123;\n/;	# left curly brace
s/\n|/\&#124;\n/;	# vertical bar
s/\n}/\&#125;\n/;	# right curly brace
s/\n~/\&#126;\n/;	# tilde

### ASCII Device Control Characters
s/\n\d00/\&#00;/g;	# (NUL) null character
s/\n\d01/\&#01;/g;	# (SOH) start of header
s/\n\d02/\&#02;/g;	# (STX) start of text
s/\n\d03/\&#03;/g;	# (ETX) end of text
s/\n\d04/\&#04;/g;	# (EOT) end of transmission
s/\n\d05/\&#05;/g;	# (ENQ) enquiry
s/\n\d06/\&#06;/g;	# (ACK) acknowledge
s/\n\d07/\&#07;/g;	# (BEL) bell (ring)
s/\n\d08/\&#08;/g;	# (BS) backspace
s/\n\d09/\&#09;/g;	# (HT) horizontal tab
s/\n\d10/\&#10;/g;	# (LF) line feed
s/\n\d11/\&#11;/g;	# (VT) vertical tab
s/\n\d12/\&#12;/g;	# (FF) form feed
s/\n\d13/\&#13;/g;	# (CR) carriage return
s/\n\d14/\&#14;/g;	# (SO) shift out
s/\n\d15/\&#15;/g;	# (SI) shift in
s/\n\d16/\&#16;/g;	# (DLE) data link escape
s/\n\d17/\&#17;/g;	# (DC1) device control 1
s/\n\d18/\&#18;/g;	# (DC2) device control 2
s/\n\d19/\&#19;/g;	# (DC3) device control 3
s/\n\d20/\&#20;/g;	# (DC4) device control 4
s/\n\d21/\&#21;/g;	# (NAK) negative acknowledge
s/\n\d22/\&#22;/g;	# (SYN) synchronize
s/\n\d23/\&#23;/g;	# (ETB) end transmission block
s/\n\d24/\&#24;/g;	# (CAN) cancel
s/\n\d25/\&#25;/g;	# (EM) end of medium
s/\n\d26/\&#26;/g;	# (SUB) substitute
s/\n\d27/\&#27;/g;	# (ESC) escape
s/\n\d28/\&#28;/g;	# (FS) file separator
s/\n\d29/\&#29;/g;	# (GS) group separator
s/\n\d30/\&#30;/g;	# (RS) record separator
s/\n\d31/\&#31;/g;	# (US) unit separator
s/\n\d12/\&#127;/g;	# (DEL) delete (rubout)

t main;

s/\n//g;
