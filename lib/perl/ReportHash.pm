use strict;
{
  package ReportHash::Real;
  our (%name);
  use Data::Dumper;
  sub DESTROY {
    my $self=shift;
    my $hash=${$self};
    my $name=$name{$hash};
    warn "DESTR($name)\n";
  };
  sub TIEHASH  {
    my $class = shift;
    my $hash = shift;
    my $name=join('#','HASH',scalar(%name));
    my $self = \$hash;
    bless $self, $class;
    $name{$self}=$name;
    $name{$hash}=$name;
    warn "TIEHASH($class,$name)\n";
    $self;
  }
  sub STORE {
    my $self=shift;
    my $hash=$$self;
    my $name=$name{$hash};
    die "missing name", Dumper(\%name) unless defined $name;
    my $key=shift;
    my $val=shift;
    warn "STORE($name,$key,$val)\n";
    $hash->{$key}=$val;
    return $val;
  }
  sub FETCH {
    my $self=shift;
    my $hash=$$self;
    my $name=$name{$hash};
    my $key=shift;
    my $val=$hash->{$key};
    warn "FETCH($name,$key)=>$val\n";
    return $val;
  };
  sub FIRSTKEY {
    my $self=shift;
    my $hash=$$self;
    keys %{$hash};
    my $key=each %{$hash};
    warn "Firstkey key=$key hash=$hash.\n";
    return $key;
  };
  sub NEXTKEY {
    my $self=shift;
    my $hash=$$self;
    my $key=each %{$hash};
    if(defined($key)){
      warn "NextKey key=$key hash=$hash.\n";
    } else {
      warn "NextKey key=<un> hash=$hash.\n";
    };
    return $key;
  };
  sub SCALAR {
    my $self=shift;
    my $hash=$$self;
    my $scalar=scalar(%{$hash});
    warn "SCARAR($hash)=$scalar.\n";
    return $scalar;
  };
  sub DELETE {
    my $self=shift;
    my $hash=$$self;
    my $name=$name{$hash};
    my $key=shift;
    my $val=delete $hash->{$key};
    warn "DELET($name,$key,$val)\n";
  }
  sub CLEAR {
    my $self=shift;
    my $hash=$$self;
    my $name=$name{$hash};
    warn "CLEAR($name)\n";
  };
  sub EXISTS {
    my $self=shift;
    my $hash=$$self;
    my $name=$name{$hash};
    my $key=shift;
    my $res=exists $hash->{$key};
    warn "EXIST($name)=>$res\n";
  };
  sub UNTIE {
    my $self=shift;
    my $hash=$$self;
    my $name=$name{$hash};
    warn "UNTIE($name)\n";
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

    goto &$AUTOLOAD;
  };
};
1;
