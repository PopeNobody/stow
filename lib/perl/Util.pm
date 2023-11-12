#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
package main;
use FindBin qw( $Dir $Script );
package Util;
use Nobody::PP qw( pp dd ppx ddx );;
sub import {
  $DB::single=1;
  #warn( pp( [caller], [@_] ) );
  require Exporter;
  $DB::single = 1;
  use Exporter qw( import );
  goto &Exporter::import;
};
push(@EXPORT_OK,qw( $Dir $Script ) );
package Util;
$\="\n";
use strict;
use warnings;
use vars qw(@fb @dd);
use autodie;
use Env qw( $HOME $PWD @PATH );
use FindBin qw( $Bin $Script);
use lib "$Bin/../lib/perl";
use lib "$Bin/lib/perl";
use lib "$HOME/lib/perl";
use Nobody::PP qw( ddx ppx dd pp );
sub sum(@){
  my $sum=0;     
  $sum+=$_ for(@_);
  return $sum;
}
sub avg(@){
  return 0 unless @_;
  return sum(@_)/@_;
};
sub max(@){
  my $max=shift;
  for(@_) {
    $max=$_ if $max>$_;
  };
  return $max;
}
sub min(@){
  my $min=shift;
  for(@_) {
    $min=$_ if $min>$_;
  };
  return $min;
}
sub mkdir_p($){
  require File::Path;
  goto &File::Path::mkpath;
};
sub basename {
  return unless @_;
  return map { $_, basename($_) } @_ unless @_ == 1;
  local $_=shift;
  s{//+}{/}g;
  s{/$}{};
  s{.*/}{} if m{/.};
  return $_;
}
sub suckdir(@){
  return grep { !m{/[.][.]?$} } map { glob("$_/* $_/.*") } @_;
}
sub suck(@){
  return warn("useless use of suck in void context") unless defined wantarray;
  return () unless @_;
  local(@ARGV)=@_;
  return <ARGV>;
};
sub spit($@){
  local($\,$/);
  my ($fn,$fh)=shift;
  use autodie qw(open close);
  $fn =~ s{^}{> } unless substr($fn,0,1) eq '|';
  open($fh,$fn);
  $fh->print($_) for join("",@_);
  close($fh);
};
1;
