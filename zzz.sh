zzz () 
{ 
    ( set -xv;
    x="$1";
    shift;
    rm -f bin/pkg-file;
    git diff origin/$x -- bin/pkg-file | patch -p1 -R;
    mv bin/pkg-file bin/pkg-file-$x )
}
