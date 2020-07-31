{
  package PATHNAME;
  use Data::Dumper;

  use Cwd qw(realpath getcwd);
  use vars qw(%data);
  use vars qw(%self @self $self);
  use vars qw(%args @args $args);
  use vars qw($class %cache @args);
  $data{cache}=\%cache;
  $data{self}=\%self;
  $data{class}=\$class;

  sub new
  {
    local(*self,*args);
    if(ref($_[0])) {
      ($class,$self)=map{ (ref($_), $_) } shift(@_);
      *self=$self;
    } else {
      die "need package" unless @_;
      $class=shift(@_);
      $self={};
      *self=$self;
    }
    $self=bless($self,$class);
    while(@_) {
      my ($k,$v) = (shift,shift);
      $self{$k}=$v;
    };
    for($self{name})
    {
      $self{segs}=[ split(qr{/+},$_) ];
      print Dumper($self{segs});
      if(length($self{segs}[0])){
        unshift(@{$self{segs}},split(qr{/+}, getcwd));
      };
    };
    return $self;
  };
};
#    BEGIN {
#      use Data::Dumper;
#      use vars qw(@path $path);
#      $path=\@path;
#      push(@path, new PATHNAME ( name => $ENV{PWD} ));
#      print Dumper($path);
#      push(@path, new PATHNAME ( name => "bin/lspath" ));
#      print Dumper($path);
#      exit(0);
#    };
