#!/bin/bash


fixpath () 
{ 
    (($#)) || set PATH;
    unset seen
    local -A seen
    local -a  dirs=( $(IFS=:; echo ${!1}) )
    declare -p dirs
    local -i idx;
    local -i  num=${#dirs[@]};
    if true; then
      for((i=0;i<num;i++)); do
        idx=$(( num - i ));
        echo "idx=$idx num=$num"
        dir="${dirs[idx]}"
        echo "dir=$dir"
        s=${seen["$dir"]}
        seen["$dir"]=idx;
        declare -p seen
        declare -p dirs
      done
    fi
}
fixpath "$@"
