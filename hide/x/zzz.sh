zzz () 
{
  ( 
  set -xv
  #set -- master nn-desktop nn-laptop nn-cripple church;
  x="$1"; shift;

  rm -f bin/pkg-file;
  git diff origin/$x -- bin/pkg-file | patch -p1 -R;
  mv bin/pkg-file bin/pkg-file-$x
)
}
