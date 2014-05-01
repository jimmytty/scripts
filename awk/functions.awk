#!/usr/bin/gawk -f

function vchar(arg,regex){if(arg ~ regex){return 1;}else{return 0;}};

function valnum(arg){if(arg ~ /[^[:alnum:]]/){return 1;}else{return 0;}};
function valpha(arg){if(arg ~ /[^[:alpha:]]/){return 1;}else{return 0;}};
function vblank(arg){if(arg ~ /[^[:blank:]]/){return 1;}else{return 0;}};
function vcntrl(arg){if(arg ~ /[^[:cntrl:]]/){return 1;}else{return 0;}};
function vdigit(arg){if(arg ~ /[^[:digit:]]/){return 1;}else{return 0;}};
function vgraph(arg){if(arg ~ /[^[:graph:]]/){return 1;}else{return 0;}};
function vlower(arg){if(arg ~ /[^[:lower:]]/){return 1;}else{return 0;}};
function vprint(arg){if(arg ~ /[^[:print:]]/){return 1;}else{return 0;}};
function vpunct(arg){if(arg ~ /[^[:punct:]]/){return 1;}else{return 0;}};
function vspace(arg){if(arg ~ /[^[:space:]]/){return 1;}else{return 0;}};
function vupper(arg){if(arg ~ /[^[:upper:]]/){return 1;}else{return 0;}};
function vxdigit(arg){if(arg ~ /[^[:xdigit:]]/){return 1;}else{return 0;}};

function vascii(arg){
  bool = 1;
  split(arg, string, "");
  for ( str in string ){
    for ( i = 0; i <= 127; i++){
      char = sprintf("%c", i);
      if ( arg == char ){
        bool = 0;
        break;
      }
    }
  }

  if ( bool == 1 ){
    return 1;
  }
  else{
    return 0;
  }
}

function vascii_old(arg){
  ascii["\0"] = 0;
  ascii[""] = 1;
  ascii[""] = 2;
  ascii[""] = 3;
  ascii[""] = 4;
  ascii[""] = 5;
  ascii[""] = 6;
  ascii[""] = 7;
  ascii[""] = 8;
  ascii["\t"] = 9;
  ascii["\n"] = 10;
  ascii[""] = 11;
  ascii[""] = 12;
  ascii[""] = 13;
  ascii[""] = 14;
  ascii[""] = 15;
  ascii[""] = 16;
  ascii[""] = 17;
  ascii[""] = 18;
  ascii[""] = 19;
  ascii[""] = 20;
  ascii[""] = 21;
  ascii[""] = 22;
  ascii[""] = 23;
  ascii[""] = 24;
  ascii[""] = 25;
  ascii[""] = 26;
  ascii[""] = 27;
  ascii[""] = 28;
  ascii[""] = 29;
  ascii[""] = 30;
  ascii[""] = 31;
  ascii[" "] =  32;
  ascii["!"] =  33;
  ascii["\""] =  34;
  ascii["#"] =  35;
  ascii["$"] =  36;
  ascii["%"] =  37;
  ascii["&"] =  38;
  ascii["'"] =  39;
  ascii["("] =  40;
  ascii[")"] =  41;
  ascii["*"] =  42;
  ascii["+"] =  43;
  ascii[","] =  44;
  ascii["-"] =  45;
  ascii["."] =  46;
  ascii["/"] =  47;
  ascii["0"] =  48;
  ascii["1"] =  49;
  ascii["2"] =  50;
  ascii["3"] =  51;
  ascii["4"] =  52;
  ascii["5"] =  53;
  ascii["6"] =  54;
  ascii["7"] =  55;
  ascii["8"] =  56;
  ascii["9"] =  57;
  ascii[":"] =  58;
  ascii[";"] =  59;
  ascii["<"] =  60;
  ascii["="] =  61;
  ascii[">"] =  62;
  ascii["?"] =  63;
  ascii["@"] =  64;
  ascii["A"] =  65;
  ascii["B"] =  66;
  ascii["C"] =  67;
  ascii["D"] =  68;
  ascii["E"] =  69;
  ascii["F"] =  70;
  ascii["G"] =  71;
  ascii["H"] =  72;
  ascii["I"] =  73;
  ascii["J"] =  74;
  ascii["K"] =  75;
  ascii["L"] =  76;
  ascii["M"] =  77;
  ascii["N"] =  78;
  ascii["O"] =  79;
  ascii["P"] =  80;
  ascii["Q"] =  81;
  ascii["R"] =  82;
  ascii["S"] =  83;
  ascii["T"] =  84;
  ascii["U"] =  85;
  ascii["V"] =  86;
  ascii["W"] =  87;
  ascii["X"] =  88;
  ascii["Y"] =  89;
  ascii["Z"] =  90;
  ascii["["] =  91;
  ascii["\\"] =  92;
  ascii["]"] =  93;
  ascii["^"] =  94;
  ascii["_"] =  95;
  ascii["`"] =  96;
  ascii["a"] =  97;
  ascii["b"] =  98;
  ascii["c"] =  99;
  ascii["d"] =  100;
  ascii["e"] =  101;
  ascii["f"] =  102;
  ascii["g"] =  103;
  ascii["h"] =  104;
  ascii["i"] =  105;
  ascii["j"] =  106;
  ascii["k"] =  107;
  ascii["l"] =  108;
  ascii["m"] =  109;
  ascii["n"] =  110;
  ascii["o"] =  111;
  ascii["p"] =  112;
  ascii["q"] =  113;
  ascii["r"] =  114;
  ascii["s"] =  115;
  ascii["t"] =  116;
  ascii["u"] =  117;
  ascii["v"] =  118;
  ascii["w"] =  119;
  ascii["x"] =  120;
  ascii["y"] =  121;
  ascii["z"] =  122;
  ascii["{"] =  123;
  ascii["|"] =  124;
  ascii["}"] =  125;
  ascii["~"] =  126;
  ascii[""] = 127;

  split(arg, char, "");

  bool = 0;
  for ( i in char ){
    if ( ascii[char[i]] == "" ){
      bool = 1;
    }
  }
  if ( bool == 1 ){
    return 1;
  }
  else{
    return 0;
  }
};


function vlen(len,arg){if(length(arg)!=len){return 1}else{return 0}};


function vuf(arg){
  bool = 1;
  split("AC,AL,AM,BA,CE,DF,ES,GO,MA,MG,MS,MT,PA,PB,PE,PI,PR,RJ,RO,RR,RS,SC,SE,SP,TO", uf, ",");
  for ( i in uf ){
    if ( arg == uf[i] ){
      bool = 0;
      break;
    }
  }

  if( bool == 1 ){
    return 1;
  }
  else{
    return 0;
  }
};
