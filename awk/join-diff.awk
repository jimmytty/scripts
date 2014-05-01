#!/usr/bin/gawk -f

BEGIN{
  OFS = FS;
  i = 0;
  usage = "usage: gawk -f join-diff.awk -v j='f1,f2' <file1> <file2>";
  if (( ARGV[2] == "" ) || ( j == "" )){
    print usage;
    exit 1;
  }
  split(j, f, "[ ,.:;]");
};
{
  i = 0;
  if ( FILENAME == ARGV[1] ){
    pk[NR] = $f[1];
  }
  if ( FILENAME == ARGV[2] ){
    for ( key in pk ){
      if ( pk[key] == $f[2] ){
        i++;
        break;
      }
    }
    if ( i == 0 ){
      print $f[2];
    }
  }
};
