#!/usr/bin/awk -f

BEGIN{
  FS="[./]";
}{
  ip[NR]=sprintf("%03d.%03d.%03d.%03d",$1,$2,$3,$4)"/"$5;
}END{
  asort(ip);
  for (i=1;i<=NR;i++){
    split(ip[i], sip);
    print sprintf("%d.%d.%d.%d",sip[1],sip[2],sip[3],sip[4])"/"sip[5];
  }
}
