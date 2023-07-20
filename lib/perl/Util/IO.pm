#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
eval 'exec perl -x -wS $0 ${1+"$@"}'
  if 0;

use strict;
use warnings;
BEGIN {
  use FindBin qw($Bin $Script);
  use lib "$Bin/../lib/perl";
  $|++; $\="\n"; $,=" "; $"=" "; $/="\n";
};
use autodie qw(:all);
use Data::Dump;
use Data::Dump qw(dd pp ddx ppx quote);
