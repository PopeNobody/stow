qqq () 
{ 
  echo "set -xv";
  echo git checkout $1;
  echo set -- ../branches/$1/. 
  echo set -- "\$@" cp -aR $PWD/. ../branches/$1/.;
  echo echo '"( $@ )"'
  echo 'printf "%s\n" "$@"'
  echo mkdir -p ${!#};
  echo "report" "$@"
}
serdate=20200731-031231
PROMPT_COMMAND="echo $serdate; source qqq.sh"
