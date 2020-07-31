#!/usr/bin/perl

use strict;
use warnings;
use autodie qw(:all);
use autodie qw(fork);
use Cwd qw(realpath getcwd);
use vars qw(@path  );
use vars qw(@build @exist);
use Data::Dumper;

use File::stat;
$|++;
$\="\n";
if(!@ARGV) {
  die "usage: $0 [script and args ...] ...\n...";
};

sub splitpath($);
sub splitname($);
sub fixpath($);

our($path,%data,$data,$script,@args,@parts);
($script,@args) =splice(@ARGV);
%data=(
  cwd=>[ getcwd() ],
  path=>[ splitpath($ENV{PATH}) ],
  script=> \$script,
  args=>\@args,
  build=>\@build,
  exist=>\@exist,
  parts=>\@parts,
);
$data=\%data;
$data{fullscript}=join("",fixpath($script));
@build=splitname($data{fullscript});
sub build_path(@) {
  my @paths;
  local ($_);
  while(@_) {
    push(@paths,$_=join("/",$_,shift(@_)));
    $_='' if $_ eq '/';
  };
  print Dumper(\@paths);
  @paths;
};
@build=build_path(@build);
@exist=grep { -e } @build;
print Dumper($data);
{
  sub xsplitname($) {
    local @_ = split(qr{/+},shift);
    return @_;
  };
  sub xfixpath($) {
    local(@_,$_)=shift;
    ($_,@_)=split(qr{/+},shift);
    if(length) {
      (@_,$_)=(split(qr{/+},getcwd()), $_, @_);
    } else {
      (@_,$_)=($_,@_);
    };
    @_=join("/",@_);
    return shift(@_);
  };
  sub xsplitpath($)
  {
    return map { split qr{:+} } @_;
  };
  sub fixpath($) { 
    print("fixpath(@_)");
    @_=xfixpath(shift);
    print("fixpath(@_)");
    return @_;
  };

  sub splitname($) { 
    print "splitname(@_)";
    (@_)=xsplitname(shift);

    print("         (@_)");
    return @_;
  };

  sub splitpath($) { 
    print "splitpath(@_)";
    (@_)=xsplitpath(shift);
    print("         (@_)");
    return @_;
  };
};
__DATA__
die "no script found" unless defined $script;

open(STDIN,"</dev/null");
use IO::Pipe;
my $out = new IO::Pipe;
my $err = new IO::Pipe;

if( !fork ) {
  open(STDOUT,">&".fileno($out->writer)) or die;
  open(STDERR,">&".fileno($err->writer)) or die;
  close($out);
  close($err);
  exec "perl", $script, @ARGV;
  die "failed!";
};
use IO::Select;
my $sel = new IO::Select;
my $out_buf="";
my $err_buf="";
$sel->add( [ $out->reader(), \$out_buf, 0 ] );
$sel->add( [ $err->reader(), \$err_buf, 1 ] );
while($sel->handles){
  my @can=$sel->can_read;
  for(@can)
  {
    my ($pipe,$ref,$stream);
    ( $pipe, $ref, $stream ) = @$_;
    local (*_)=$ref;
    my $res=sysread($pipe,$_,1,length);
    if(!defined($res)) {
      die "sysread:$!";
    } elsif ( !$res ) {
      $sel->remove($pipe);
      close($pipe) or die "close:$!";
      $_="$_\n" if length($$ref);
    };
    next unless chomp;
    if($stream && s{ at (\S+) line (\d+)\.*}{})
    {
      my ($file,$line) = ($1,$2);
      s{^\t(.*)called\s*$}{called from $1};
      print STDERR "$file:$line: msg $_";
    } else {
      print STDOUT "$_";
    };
    $_="";
  };
};
