#!/bin/bash

set --  church nn-cripple nn-desktop nn-laptop nn-yy root_standard
doit() {
  m=master
  while (($#)); do
    echo
    echo
    echo echo vers: $m $1
    echo git diff $m $1 -- .gitignore
    shift
  done
};
doit "$@"
