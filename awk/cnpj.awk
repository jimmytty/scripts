#!/usr/bin/awk -f

BEGIN{
  i=1
}{
  cnpj=gensub("[ ./-]","","g",$0)
  len=length(cnpj)
  while (i <= len){
    dig[i]=substr(cnpj,i,1)
    i++
  }
}
END{
  j=1
  l=5
  sum=0
  while (j < 5 ){
    calc[j]=(dig[j] * l)
    sum=sum+calc[j]
    j++
    l--
  }
  l=9
  while (j < 13 ){
    calc[j]=(dig[j] * l)
    sum=sum+calc[j]
    j++
    l--
  }
  calc[j]=sum%11
  if (calc[j] < 2){
    v1=0
  }
  else{
    v1=11-calc[j]
  }

  j=1
  l=6
  sum=0
  while (j < 6){
    calc[j]=(dig[j] * l)
    sum=sum+calc[j]
    j++
    l--
  }
  l=9
  while (j < 14 ){
    calc[j]=(dig[j] * l)
    sum=sum+calc[j]
    j++
    l--
  }
  calc[j]=sum%11
  if (calc[j] < 2){
    v2=0
  }
  else{
    v2=11-calc[j]
  }

  if ((v1 == dig[(j-1)]) && (v2 == dig[j])){
    print "TRUE"
  }
  else {
    print "FALSE"
  }
}
