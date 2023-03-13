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
sub DESTROY {
	print Dumper(\@_),"\n\n";
	my $self=shift;
	my $hash=${$self};
	my $name=$name{$hash};
	carp "DESTR($name)\n";
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
	carp "TIEHASH($class,$name)\n";
	$self;
}
sub STORE {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	die "missing name", Dumper(\%name) unless defined $name;
	my $key=shift;
	my $val=shift;
	carp "STORE($name,$key,$val)\n";
	$hash->{$key}=$val;
	return $val;
}
sub FETCH {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	my $key=shift;
	my $val=$hash->{$key};
	carp "FETCH($name,$key)=>$val\n";
	return $val;
};
sub FIRSTKEY {
	my $self=shift;
	my $hash=$$self;
	keys %{$hash};
	my $key=each %{$hash};
	carp "Firstkey key=$key hash=$hash.\n";
	return $key;
};
sub NEXTKEY {
	my $self=shift;
	my $hash=$$self;
	my $key=each %{$hash};
	if(defined($key)){
		carp "NextKey key=$key hash=$hash.\n";
	} else {
		carp "NextKey key=<un> hash=$hash.\n";
	};
	return $key;
};
sub SCALAR {
	my $self=shift;
	my $hash=$$self;
	my $scalar=scalar(%{$hash});
	carp "SCARAR($hash)=$scalar.\n";
	return $scalar;
};
sub DELETE {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	my $key=shift;
	my $val=delete $hash->{$key};
	carp "DELET($name,$key,$val)\n";
}
sub CLEAR {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	carp "CLEAR($name)\n";
};
sub EXISTS {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
	my $key=shift;
	my $res=exists $hash->{$key};
	carp "EXIST($name)=>$res\n";
};
sub UNTIE {
	my $self=shift;
	my $hash=$$self;
	my $name=$name{$hash};
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
};
1;
