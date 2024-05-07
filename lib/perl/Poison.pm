package Poison;
sub TIESCALAR {
  my $s;
  return bless(\$s);
};
sub TIEARRAY {
  return bless([]);
};
sub TIEHASH {
  return bless({});
};
sub TIEHANDLE {
  local (*STDOUT);
  return bless(\*STDOUT);
};
return 1 if caller;
use Nobody::PP qw(:all);
ddx([caller]);
1;
