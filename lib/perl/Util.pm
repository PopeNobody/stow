#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
eval 'exec perl -x -wS $0 ${1+"$@"}'
  if 0;

package Util;

use strict;
use warnings;
our($DEBUG)=0;
use FindBin qw($Bin $Script);
use lib "$Bin/../lib/perl";
use autodie qw(:all);
use Data::Dump;
require Exporter;
our(@ISA)=qw(Exporter);
our(@EXPORT)=qw(suck spit);

sub suck(@);
sub suck(@){
  print STDERR "wantarray: ", wantarray, "\n" if $DEBUG;
  if(wantarray) {
    local(@ARGV,@_)=("/dev/null", @_);
    return <ARGV>;
  } else {
    return join("",suck(@_));
  };
};
sub spit($@);
sub spit($@){
  local($\,$/);
  my ($fn,$fh)=shift;
  use autodie qw(open close);
  print STDERR "writing to $fn\n";
  open($fh,">",$fn);
  $fh->print($_) for join("",@_);
  close($fh);
};
1;
