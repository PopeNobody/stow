make_run () 
{ 
    report make -f Makefile -Rr --warn-undefined-variable
}
make_log () 
{ 
    tee log/make.out 2>&1
}
make_pipe () 
{ 
    make_run 2>&1 | make_log
}

make_pipe;
