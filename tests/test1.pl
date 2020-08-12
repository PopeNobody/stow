#!/usr/bin/perl

my $msg=0;
while(<STDIN>) {
  print join("",__FILE__,__LINE__," line#: $. line: $_");
  ++$msg;
}
exit(($.%2));
