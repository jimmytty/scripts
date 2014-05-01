#!/usr/bin/gawk -f

BEGIN{
  i=0;
  max=1024;
};

{
  args=args" "$1;
  i++;
  if(i==max){
    system(cmd args);
    i=0;
    args="";
  }
};
