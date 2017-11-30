
use 5.010;
use strict;
use warnings;

package Perl::PrereqScanner::Scanner::Jojo;

# ABSTRACT: Scan for modules loaded with Jojo::Base

use Moose;
extends 'Perl::PrereqScanner::Scanner::Mojo';

sub _is_base_module { $_[1] eq 'Jojo::Base' }

1;

=encoding utf8

=head1 SYNOPSIS

    use Perl::PrereqScanner;
    my $scanner = Perl::PrereqScanner->new( { extra_scanners => ['Jojo'] } );
    my $prereqs = $scanner->scan_ppi_document($ppi_doc);
    my $prereqs = $scanner->scan_file($file_path);
    my $prereqs = $scanner->scan_string($perl_code);
    my $prereqs = $scanner->scan_module($module_name);

=head1 DESCRIPTION

This scanner will look for dependencies from the L<Mojo::Base> module:

    use Jojo::Base 'SomeBaseClass';
