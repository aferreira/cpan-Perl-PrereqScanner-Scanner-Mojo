
use 5.010;
use strict;
use warnings;

package Perl::PrereqScanner::Scanner::Mojo;

# ABSTRACT: Scan for modules loaded with Mojo::Base

use Moose;
with 'Perl::PrereqScanner::Scanner';

sub scan_for_prereqs {
    my ( $self, $ppi_doc, $req ) = @_;

    state $IS_BASE = { 'Mojo::Base' => 1, 'Jojo::Base' => 1 };

    # regular use, require, and no
    my $includes = $ppi_doc->find('Statement::Include') || [];
    for my $node (@$includes) {

        # inheritance
        if ( $IS_BASE->{ $node->module } ) {

            # skip arguments like '-base', '-strict', '-role', '-signatures'
            my @meat = grep {
                     $_->isa('PPI::Token::QuoteLike::Words')
                  || $_->isa('PPI::Token::Quote')
                  || $_->isa('PPI::Token::Number')
            } $node->arguments;

            my @args = map { $self->_q_contents($_) } @meat;

            while (@args) {
                my $module  = shift @args;
                my $version = '0';
                $req->add_minimum( $module => $version );
            }
        }
    }
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Perl::PrereqScanner;
    my $scanner = Perl::PrereqScanner->new( { extra_scanners => 'Mojo' } );
    my $prereqs = $scanner->scan_ppi_document($ppi_doc);
    my $prereqs = $scanner->scan_file($file_path);
    my $prereqs = $scanner->scan_string($perl_code);
    my $prereqs = $scanner->scan_module($module_name);

=head1 DESCRIPTION

This scanner will look for dependencies from the L<Mojo::Base> module:

    use Mojo::Base 'SomeBaseClass';
