do_do_one () 
{
  (($#<2)) && echo fuck && return 1;
  echo $(printf " (%s) " "$@" ) xxx
  x="$1"; shift 2; set -- "$x" "$@"
  diff --color=auto $1 $2
}
do_one() {
  set -- bin/pkg-file*
  export -f do_do_one;
  bash -c "set -xv; do_do_one bin/pkg-file*"
};
