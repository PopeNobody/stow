#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
{

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

  my @dd = qw(ddx ppx dd pp quote);

  {
    package main;
    use Data::Dump @dd;
  };
  use Data::Dump @dd;

  sub suck(@);
  sub spit($@);


  sub suck(@){
    print STDERR "wantarray: ", wantarray, "\n" if $DEBUG;
    return warn("useless use of suck in void context") unless defined wantarray;

    if(wantarray) {
      local(@ARGV,@_)=("/dev/null", @_);
      return <ARGV>;
    } else {
      return join("",suck(@_));
    };
  };
  sub spit($@){
    local($\,$/);
    my ($fn,$fh)=shift;
    use autodie qw(open close);
    print STDERR "writing to $fn\n";
    open($fh,">",$fn);
    $fh->print($_) for join("",@_);
    close($fh);
  };
}
1;
