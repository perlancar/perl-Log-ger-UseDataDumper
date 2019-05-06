package Log::ger::UseDataDumper;

# DATE
# VERSION

use Data::Dumper ();
use Log::ger ();
use strict 'subs', 'vars';
use warnings;

my @known_configs = qw(
                          Indent Trailingcomma Purity Pad Varname Useqq Terse
                          Freezer Toaster Deepcopy Bless Pair Maxdepth
                          Maxrecurse Useperl Sortkeys Deparse parseseen);

my %default_configs = (
    Indent => 1,
    Purity => 1,
    Terse  => 1,
    Useqq  => 1,
);

sub import {
    my ($pkg, %args) = @_;
    my %configs = %default_configs;
    for my $k (sort keys %args) {
        die unless grep { $k eq $_ } @known_configs;
        $configs{$k} = $args{$k};
    }

    $Log::ger::_dumper = sub {
        my %orig_configs;
        for (keys %configs) {
            $orig_configs{$_} = ${"Data::Dumper::$_"};
            ${"Data::Dumper::$_"} = $configs{$_};
        }
        my $res = Data::Dumper::Dumper(@_);
        for (keys %configs) {
            ${"Data::Dumper::$_"} = $orig_configs{$_};
        }
        $res;
    };
}

1;
# ABSTRACT: Use Data::Dumper (with nicer defaults) to dump data structures

=head1 SYNOPSIS

 use Log::ger::UseDataDumper;

To configure Data::Dumper:

 use Log::ger::UseDataDumper (Indent => 0, Purity => 0);


=head1 DESCRIPTION

This module sets the L<Log::ger> dumper to L<Data::Dumper>, which by default is
already the case but in this edition the default configuration is somewhat
closer to that of L<Data::Dump>:

 Indent => 1,
 Purity => 1,
 Terse  => 1,

This module also lets you configure Data::Dumper during import (see example in
Synopsis).


=head1 SEE ALSO

L<Log::ger>

L<Data::Dumper>

L<Log::ger::UseDataDump>, L<Log::ger::UseDataDumpColor>


=cut
