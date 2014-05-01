#!/usr/bin/gawk -f

function vcpf(cpf){
  cpf = gensub("[^0-9]","","g",cpf);
  if (length(cpf) != 11){
    return 1;
    exit 1;
  }
  else{
    nf = split(cpf,n,"");
    split("11,10,9,8,7,6,5,4,3,2",m,",");
    i = 1;
    j = 1;
    for (k = 0; k < 2; k++){
      if (i == 1){
        len = 9;
        l = 2;
      }
      else{
        if (i == 2){
          j = 1;
          len = 10;
          l = 1;
        }
      }
      calc=0;
      while(j <= len){
        calc += n[j] * m[l];
	j++;
	l++;
      }
      calc %= 11;
      if (calc < 2){
        calc = 0;
      }
      else{
        calc = 11 - calc;
      }
      if (calc != n[j]){ 
        return 1;
      }
      i++;
    }
  }
};
