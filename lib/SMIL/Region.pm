package SMIL::Region;

$VERSION = "0.891";

@ISA = qw( SMIL::XMLTag );

sub init {
    my $self = shift;
    $self->SUPER::init( "region" );    
}

sub getAttributeValue
{
    my $self = shift;
    my $attr = shift;
    return $self->{ _attributes }->{ $attr };
}
