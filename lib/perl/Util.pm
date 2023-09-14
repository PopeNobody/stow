#!/usr/bin/perl
# vim: ts=2 sw=2 ft=perl
{
  $DB::single=1;

  package Util;

  use strict;
  use warnings;
  our($DEBUG)=0;
  use vars qw(@fb @dd);
  use autodie qw(:all);
  BEGIN {
    @fb = qw($Bin $Script);
    @dd = qw( ddx ppx dd pp );
  }
  use FindBin @fb;
  use lib "$Bin/../lib/perl";
  use lib "$Bin/lib/perl";
  use Nobody::PP;
  use Scalar::Util;
  our(@EXPORT)=(qw(mkdir_p suckdir suck spit min max), @fb, @dd);
  require Exporter;
  our(@ISA)=qw(Exporter);
  $|++; $\="\n"; $/="\n";

  sub suck(@);
  sub spit($@);
  sub max(@);
  sub min(@);

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
  
  sub dotfilter{ grep { /[^.]/ || length > 2 } @_ ; };
  sub suckdir($){
    my ($dir) = @_;

    die "dir should be defined, and have a length. ", dd($dir)
      unless defined($dir) && length($dir);
    die "dir should be a dir: $dir" unless -d $dir;
    opendir(my $dh, "$dir");
    local(@_) = readdir($dh);
    @_ = dotfilter(@_);
    closedir($dh);
    return @_;
  }
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
    $fn =~ s{^}{> } unless substr($fn,0,1) eq '|';
    open($fh,$fn);
    $fh->print($_) for join("",@_);
    close($fh);
  };
}
1;
