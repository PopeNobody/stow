x () 
{ 
    git checkout $c;
    mv bin/pkg-file bin/pkg-file-$c;
    git diff -- bin/pkg-file | patch -p1 -R;
    echo $'\n\n'
    git checkout $m;
    mv bin/pkg-file bin/pkg-file-$m;
    git diff -- bin/pkg-file | patch -p1 -R
    echo $'\n\n'
    md5sum bin/pkg-f*
}
