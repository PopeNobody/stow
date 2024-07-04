# -*- Mode: cperl; coding: utf-8; cperl-indent-level: 4 -*-
# vim: ts=4 sts=4 sw=4:
use strict;
BEGIN {
  unless($<) {
    if($ENV{DONE}){
      warn "not cleaning env";
    } else {
      for( sort grep{!/CANARY/} grep {/PERL/} keys %ENV ) {
        warn("$_\n");
        delete $ENV{$_};
      }
    }
    $ENV{DONE}=1;
    warn "pristine now\n";
  };
  $ENV{PERL_CANARY_STABILITY_NOPROMPT}=1;
  for(@INC) {
      next unless -e "$_/CPAN.pm";
      require "$_/CPAN.pm";
  };
};
1;
