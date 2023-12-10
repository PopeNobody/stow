#!/bin/bash


cd /etc/perl
set $( find -name '*.pm' | xargs -r md5sum )
declare -A opt etc
while (($#)) ; do
  etc[$1]="$2";
  shift 2
done
cd -
cd perl
set $( find -name '*.pm' | xargs -r md5sum )
while (($#)) ; do
  etc[$1]="$2";
  shift 2
done
for i in "${etc:@K}"; do echo $i; done

