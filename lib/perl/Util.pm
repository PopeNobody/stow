package Util;
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../lib/perl";
use Data::Dumper;
our(@ISA) =qw(Data::Dumper Exporter);
our(@EXPORT_OK,@EXPORT);
BEGIN {
  @EXPORT=@EXPORT_OK=qw(DD);
  local $\="\n";
  $|++;
};


sub DD
{
  local $Data::Dumper::Sortkeys=1;
  local $Data::Dumper::Useqq=1;
  local $Data::Dumper::Terse=1;
  Dumper( \@_ );
};

sub eval_and_warn
{
  for( splice @_ ) {
    my @val = eval $_;
    @val=[@val] if @val > 1;
    @val=DD(@val);

    push(@_, $_ , [ eval $_ ]);
  };
  print DD({ @_ });
};
1;
__DATA__
BEGIN {
  local(@ARGV) = qw( $0 \@ARGV \@INC \%INC \%ENV  );
  @ARGV= map { split } @ARGV;
  eval_and_warn(@ARGV);
};
1;
