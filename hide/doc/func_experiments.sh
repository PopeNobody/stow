x () 
{ 
  (($#)) || set -- church master nn-cripple nn-desktop nn-laptop;
    for i in "$@";
    do
      echo
      echo echo "doing: $i"
      echo
        echo git checkout master;
        echo git checkout $i;
        echo "echo $i | tee doc/ver";
        echo git commit doc/ver;
        echo git push;
        echo;
    done
}
