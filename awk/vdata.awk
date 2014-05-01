#!/usr/bin/gawk -f

function vdata(yy,mm,dd){

  yy=(yy * 1);
  mm=(mm * 1);
  dd=(dd * 1);
  i=0;
  j=0;
  max=0;

  split("1,3,5,7,8,10,12",m31,",");
  split("4,6,9,11",m30,",");

  if ((mm < 1) || (mm > 12)){
    i=1;
  }
  else{
    for (j in m31){ 
      if (mm == m31[j]){
        max=31;
      }
    } 
    if (max == 0){ 
      for (j in m30){
        if (mm == m30[j]){
          max=30;
        }
      }
    }
    if (max == 0){
      if ((yy % 4) == 0){
        max=29;
      }
      else{
        max=28;
      }
    }
    if (((dd * 1) < 1) || ((dd * 1) > max)){
      i=1;
    }
  }
  
  if (i == 1){
    return 1;
  }
  else{
    return 0;
  }

};

BEGIN{
  IFS=" ";
};

{
if (NF == 0){exit 1};
if ((vdata($1,$2,$3)) == 1){
  print "data inválida";
}
};

