package SMIL::Code;

$VERSION = "0.86";

sub getAsString {
	my $self = shift;
	return $self->{code}; 
}

sub new {
    my $type = shift;
    my $self = {};
    bless $self, $type;

    $self->{code} = shift;
    return $self;
}


