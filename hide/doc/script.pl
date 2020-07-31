use DB;
use Carp qw(confess);

BEGIN {
  $DB::single=1;
};

sub s1 {
  print "s1(@_)\n";
  s2(@_);
};
sub s2{
  print "s2(@_)\n";
  s3(@_);
};
sub s3{
  print "s3(@_)\n";
  s4(@_);
};
sub s4 {
  print "s4(@_)\n";
  confess("fucked(@_);");
}
s1(@ARGV);
