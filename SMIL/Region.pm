package SMIL::Region;

$VERSION = "0.86";

@ISA = qw( SMIL::XMLTag );

sub init {
    my $self = shift;
    $self->SUPER::init( "region" );    
}
