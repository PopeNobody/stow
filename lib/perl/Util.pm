#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
{
  package Util;
  $/="\n";
  use strict;
  use warnings;
  our($DEBUG)=0;
  use vars qw(@fb @dd @ISA @EXPORT);
  use autodie qw(:default);
  BEGIN {
    @fb = qw($Bin $Script);
    @dd = qw( ddx ppx dd pp );
  }
  use FindBin @fb;
  use lib "$Bin/../lib/perl";
  use lib "$Bin/lib/perl";
  use Nobody::PP @dd;
  our(@EXPORT)=(qw(mkdir_p suckdir suck spit min max sum avg), @fb, @dd);
  require Exporter;
  our(@ISA)=qw(Exporter);

  sub sum(@){
    my $sum=0;     
    for(@_){
      $sum+=$_;
    };
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
    print STDERR "wantarray: ", wantarray, "\n" if $DEBUG;
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
}
1;
