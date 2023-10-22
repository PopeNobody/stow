#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
eval 'exec perl -x -wS $0 ${1+"$@"}'
  if 0;

use strict;
use warnings;
use Util;

use Env qw($HOME, @PATH);
$ENV{LANG}="C";
