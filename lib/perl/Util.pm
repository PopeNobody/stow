#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
package Util;
our ( @EXPORT, @EXPORT_OK, @ISA );
use vars qw(@dd);
BEGIN {
  @pp=qw( pp dd ppx ddx quote qquote );
};
use Nobody::PP @pp;
use FindBin;
use FindBin @FindBin::EXPORT_OK;
$\="\n";
BEGIN {
  push(@EXPORT_OK,@FindBin::EXPORT_OK);
  push(@EXPORT_OK,@Nobody::PP::EXPORT_OK);
  push(@EXPORT_OK,
    qw( sum avg max min mkdir_p basename suckdir suck spit maybeRef )
  );
  push(@EXPORT_OK,
    qw( pasteLines )
  );
}
use strict;
use warnings;
use autodie;
use Env qw( $HOME $PWD @PATH );
use lib "/opt/lib/perl";
use lib "$HOME/lib/perl";
BEGIN {
  @EXPORT=@EXPORT_OK;
  @ISA=qw(Exporter);
  require Exporter;
  sub import {
    goto &Exporter::import;
  };
}
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
  for(grep { defined } @_) {
    $max=$_ if $max<$_;
  };
  return $max;
}
sub min(@){
  my $min=shift;
  for(grep { defined } @_) {
    $min=$_ if $min>$_;
  };
  return $min;
}
sub basename {
  return unless @_;
  return map { $_, basename($_) } @_ unless @_ == 1;
  local $_=shift;
  s{//+}{/}g;
  s{/$}{};
  s{.*/}{} if m{/.};
  return $_;
}
sub suckdir(@);
sub suckdir(@){
  return map { suckdir($_) } @_ unless @_ == 1;
  for(shift) {
    die "undefined dirname" unless defined;
    if(length) {
      return grep { !m{/[.][.]?$} } glob("$_/* $_/.*");
    } else {
      return grep { s{^\./}{} } suckdir(".");
    };
  }
}
sub suck(@){
  return warn("useless use of suck in void context") unless defined wantarray;
  local(@ARGV)=@_;
  local(@_)=<ARGV>;
  return join("",@_) unless wantarray;
  return @_;
};
sub pasteLines(@) {
  for(join("",@_)){
    s{\\\n?$}{}sm;
  }
  return join("\n",@_) unless wantarray;
  return @_;
}
sub spit($@){
  local($\,$/);
  my ($fn,$fh)=shift;
  use autodie qw(open close);
  $fn =~ s{^}{> } unless substr($fn,0,1) eq '|';
  open($fh,$fn);
  $fh->print($_) for join("",@_);
  close($fh);
};
sub maybeRef($) {
  return ref || $_ for shift;
};
1;
