#!/usr/bin/gawk -f

{
  for ( i = 1; i <= NF; i++ ){
    if ( length($i) > len[i] ){
      len[i] = length($i);
    }
  }
};
END{
  for ( i = 1; i <= NF; i++ ){
    if ( i == NF ){
      ORS="\n";
    }
    else {
      ORS=FS;
    }
    print len[i];
  }
}
