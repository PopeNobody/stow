<<<<<<< HEAD
use strict;
use warnings;
use autodie qw(:all);
use Carp;
#our @ISA = 'Tie::ExtraHash';
{
  package LineDump;
  our(@ISA) = qw('Data::Dumper');
  our(@EXPORTS) = qw(LineDump);
  
  sub LineDump
  {
    for( Dumper(@_) ) {
      s{\s*\n\s*}{}m;
      return "$_";
    };

  };
}
{
package ReportHash::Real;
our (%name);
use Data::Dumper;
use Carp;
=======
package ReportHash;
use strict;
use warnings;
use autodie qw(:all);
#our @ISA = 'Tie::ExtraHash';
our (%name);
use Data::Dumper;
>>>>>>> church
sub DESTROY {
	print Dumper(\@_),"\n\n";
	my $self=shift;
	my $hash=${$self};
	my $name=$name{$hash};
<<<<<<< HEAD
	carp "DESTR($name)\n";
=======
	warn "DESTR($name)\n";
>>>>>>> church
};
sub TIEHASH  {
	print Dumper(\@_),"\n\n";
	my $class = shift;
	my $hash = shift;
	my $name=join('#','HASH',scalar(%name));
	my $self = \$hash;
	bless $self, $class;
	$name{$self}=$name;
	$name{$hash}=$name;
<<<<<<< HEAD
	carp "TIEHASH($class,$name)\n";
=======
	warn "TIEHASH($class,$name)\n";
>>>>>>> church
	$self;
}
sub STORE {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	die "missing name", Dumper(\%name) unless defined $name;
	my $key=shift;
	my $val=shift;
<<<<<<< HEAD
	carp "STORE($name,$key,$val)\n";
=======
	warn "STORE($name,$key,$val)\n";
>>>>>>> church
	$hash->{$key}=$val;
	return $val;
}
sub FETCH {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	my $key=shift;
	my $val=$hash->{$key};
<<<<<<< HEAD
	carp "FETCH($name,$key)=>$val\n";
=======
	warn "FETCH($name,$key)=>$val\n";
>>>>>>> church
	return $val;
};
sub FIRSTKEY {
	my $self=shift;
	my $hash=$$self;
	keys %{$hash};
	my $key=each %{$hash};
<<<<<<< HEAD
	carp "Firstkey key=$key hash=$hash.\n";
=======
	warn "Firstkey key=$key hash=$hash.\n";
>>>>>>> church
	return $key;
};
sub NEXTKEY {
	my $self=shift;
	my $hash=$$self;
	my $key=each %{$hash};
	if(defined($key)){
<<<<<<< HEAD
		carp "NextKey key=$key hash=$hash.\n";
	} else {
		carp "NextKey key=<un> hash=$hash.\n";
=======
		warn "NextKey key=$key hash=$hash.\n";
	} else {
		warn "NextKey key=<un> hash=$hash.\n";
>>>>>>> church
	};
	return $key;
};
sub SCALAR {
	my $self=shift;
	my $hash=$$self;
	my $scalar=scalar(%{$hash});
<<<<<<< HEAD
	carp "SCARAR($hash)=$scalar.\n";
=======
	warn "SCARAR($hash)=$scalar.\n";
>>>>>>> church
	return $scalar;
};
sub DELETE {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	my $key=shift;
	my $val=delete $hash->{$key};
<<<<<<< HEAD
	carp "DELET($name,$key,$val)\n";
=======
	warn "DELET($name,$key,$val)\n";
>>>>>>> church
}
sub CLEAR {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
<<<<<<< HEAD
	carp "CLEAR($name)\n";
=======
	warn "CLEAR($name)\n";
>>>>>>> church
};
sub EXISTS {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	my $key=shift;
	my $res=exists $hash->{$key};
<<<<<<< HEAD
	carp "EXIST($name)=>$res\n";
=======
	warn "EXIST($name)=>$res\n";
>>>>>>> church
};
sub UNTIE {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
<<<<<<< HEAD
	carp "UNTIE($name)\n";
};
};
{
  package ReportHash;

  use Data::Dumper;
  our($AUTOLOAD);
  sub AUTOLOAD {
    print STDERR "AUTOLOAD: $AUTOLOAD\n"; 
    $AUTOLOAD =~ s{(.*::)(.*)}{$1Real::$2}; 
    print STDERR "AUTOLOAD: $AUTOLOAD\n";

    open(DEBUG,">>/tmp/ReportHash.$$") or die;
    print "$AUTOLOAD(@{[ Dumper(@_) ]})\n";
    close(DEBUG);
  
    goto &$AUTOLOAD;
  };
=======
	warn "UNTIE($name)\n";
>>>>>>> church
};
1;
