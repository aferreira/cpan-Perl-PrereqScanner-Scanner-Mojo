
use 5.010;
use strict;
use warnings;

package Perl::PrereqScanner::Scanner::Mojo;

# ABSTRACT: Scan for modules loaded with Mojo::Base

use Moose;
with 'Perl::PrereqScanner::Scanner';

use PPIx::Literal;

sub scan_for_prereqs {
    my ( $self, $ppi_doc, $req ) = @_;

    # regular use, require, and no
    my $includes = $ppi_doc->find('Statement::Include') || [];
    for my $node (@$includes) {

        # inheritance
        if ( $self->_is_base_module( $node->module ) ) {

            my @args = PPIx::Literal->convert( $node->arguments );

            # skip arguments like '-base', '-strict', '-role', '-signatures'
            @args = grep { !ref && !/^-/ } @args;

            if (@args) {
                my $module  = shift @args;
                my $version = '0';
                $req->add_minimum( $module => $version );
            }
        }
    }
}

sub _is_base_module { $_[1] eq 'Mojo::Base' }

1;

=encoding utf8

=head1 SYNOPSIS

    use Perl::PrereqScanner;
    my $scanner = Perl::PrereqScanner->new( { extra_scanners => ['Mojo'] } );
    my $prereqs = $scanner->scan_ppi_document($ppi_doc);
    my $prereqs = $scanner->scan_file($file_path);
    my $prereqs = $scanner->scan_string($perl_code);
    my $prereqs = $scanner->scan_module($module_name);

=head1 DESCRIPTION

This scanner will look for dependencies from the L<Mojo::Base> module:

    use Mojo::Base 'SomeBaseClass';
