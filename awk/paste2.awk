#/usr/bin/awk -f

BEGIN{
  usage = "usage: gawk -f paste2.awk -v c='f1,f2,...,fn' <file1> <file2> ... <filen>";
  if (( ARGV[2] == "" ) || ( c == "" )){
    print usage;
    exit 1;
  }
  split(c, f, "[,.:;]");
  margs = ARGC - 1;
};
{
  line[FNR] = line[FNR]""FS""$f[ARGIND];
};
END{
  for ( i = 1; i <= FNR; i++ ){
    print gensub(".","",1,line[i])
  }
};
