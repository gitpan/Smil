package SMIL::Region;

$VERSION = "0.72";

@ISA = qw( SMIL::XMLTag );

sub init {
    my $self = shift;
    $self->SUPER::init( "region" );    
}
