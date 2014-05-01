#!/usr/bin/gawk -f

BEGIN{
  OFS = FS;
  usage = "usage: gawk -f join.awk -v j='c1,c2' <file1> <file2>";
  if (( ARGV[2] == "" ) || ( j == "" )){
    print usage;
    exit 1;
  }
  split(j, f, "[ ,.:;]");
};
{
  if ( FILENAME == ARGV[1] ){
    ind[$c[1]] = $1;
  }
  else{
    if ( FILENAME == ARGV[2] ){
      print $1,ind[$c[2]];
    }
  }
};
