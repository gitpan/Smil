package SMIL::RootLayout;

$VERSION = "0.701";

use SMIL::XMLTag;

@ISA = qw( SMIL::XMLTag );

sub init {
    my $self = shift;
    $self->SUPER::init( "root-layout" );
}

sub getRootHeight {
    my $self = shift;
    return $self->getAttribute( "height" );
}

sub getRootWidth {
    my $self = shift;
    return $self->getAttribute( "width" );
}

