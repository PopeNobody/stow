#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
#
package Nobody::Util;
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
    qw( pasteLines serdate class mkref show_fds )
  );
}
use strict;
use warnings;
use feature qw(say);
use autodie;
use POSIX qw(strftime mktime );
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
sub show_fds() {
  my %links=map { $_, undef } glob("/proc/self/fd/*");
  for(keys %links) {
    if(-l) {
      $links{$_}=eval { readlink("$_") };
    } else {
      delete $links{$_}
    };
  };
  ddx(\%links);
};
sub mkdir_p($;$);
sub mkdir_p($;$) {
  no autodie qw(mkdir);
  my ($dir,$mode)=@_;
  $mode=0755 unless defined($mode);
  return 1 if -d $dir;
  return 1 if mkdir($dir,$mode);
  die "mkdir:$dir:$!" unless $!{ENOENT};
  my (@dir) = split(m{/+},$dir);
  pop(@dir);
  mkdir_p(join("/",@dir),$mode);
  mkdir($dir,$mode); 
};
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
  die("useless use of suck in void context") unless defined wantarray;
  local(@ARGV)=@_;
  local($/,$_,@_);
  $_=<ARGV>;
  if(wantarray) {
    return split(/\n/);
  } else {
    return $_;
  };
};
{
  package Null;
};
sub class($){
  return ref||$_||'Null' for @_;
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

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
my @x=qw(sec min hour mday mon year wday yday isdst);
sub serdate(;$)
{
  my $time=@_ ? $_[0] : time;
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time);
  @_=($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
  #  for(0 .. @_) {
  #  say $_, $_[$_], $x[$_];
  #};
  ddx(\@_);
  return strftime("%Y%m%d-%H%M%S-gmt", @_);
}
our(%caller);
sub deparse {
  eval "use B::Deparse";
  die "$@" if "$@";
  my $deparse = B::Deparse->new("-p", "-sC");
  return join(' ', 'sub{', $deparse->coderef2text(\&func), '}');
};
#unless(caller){
#  use Carp;
#  sub test_date(;$) {
#    $,=" ";
#    $DB::single=1;
#    $DB::single=1;
#    my $time=time;
#    say $time;
#    my (@gm);
#    my $ser=serdate($time);
#    say $ser;
#    $_=$ser;
#    #    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = 
#    ($year,$mon,$mday,$hour,$min,$sec)=map{int($_)}
#    (m{^(\d\d\d\d)(\d\d)(\d\d)-(\d\d)(\d\d)(\d\d)-gmt});
#    @_=( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst );
#    $year-=1900;
#    $mday++;
#    for(0 .. @_) {
#      my $idx="$_";
#      my $val=($_[$_]//-1);
#      my $tag=$x[$_];
#      #ddx([ $idx, $val, $tag ]);
#      #say $_, ($_[$_]//-1), ($x[$_]);
#    };
#    #ddx(\@_);
#  };
#  test_date;
#  exit(0);
#};
1;
=head1 NAME

Nobody::Util - Pretty printing of data structures

=head1 SYNOPSIS

This is a Lazy Bastard package that you probably don't want to use.
Nobody made it because Nobody is as lazy as he is.  It's full of
ugly hacks, but saves him time.

=cut

1;
