package SMIL::Head;

my $debug = 0;

$VERSION = "0.861";

use SMIL::XMLContainer;
use SMIL::XMLTag;
use SMIL::Layout;
use SMIL::Meta;
use SMIL::Transition;

@ISA = qw( SMIL::XMLContainer );

my $layout = "layout";
my $metas = "metas";
my $transitions = 'transitions';
my $meta = "meta";

sub init {
    my $self = shift;
    my %hash = @_;
    $self->SUPER::init( "head" );    
    if( $hash{ 'height' } && $hash{ 'width' } ) {
	$self->initLayout( @_ ) ;
	print "Setting layout" if $debug;
    }
    $self->initMetas( @_ ) if( $hash{ 'meta' } );
}

sub getRootHeight {
    my $self = shift;
    my $ly = $self->getContentObjectByName( $layout );
    return $ly ? $ly->getRootHeight() : 0;    
}

sub getRootWidth {
    my $self = shift;
    my $ly = $self->getContentObjectByName( $layout );
    return $ly ? $ly->getRootWidth() : 0;    
}

sub initLayout {
    my $self = shift;
    $self->{$layout} = new SMIL::Layout( @_ );
    $self->setTagContents( $layout => $self->{$layout} );
}

sub initMetas {
    my $self = shift;
    my %hash = @_;

    if( $hash{ $meta } ) {
	$self->setMeta( $hash{ $meta } );
    }
}

sub setMeta {

    my $self = shift;
    my $hash_ref = shift;
    my $meta_tags_ref = $self->getContentObjectByName( $metas );

    if( !( $meta_tags_ref && @$meta_tags_ref ) ) {
								$meta_tags_ref = [];
    }
    
    # Extract the meta tags
    foreach $name ( keys %$hash_ref ) {
								my $meta = new SMIL::Meta( $name, $$hash_ref{ $name } );
								# Now, push it on the stack of meta tags
								push @$meta_tags_ref, $meta;
    }
				
#    $self->{$metas} = $meta_tags_ref;
    $self->setTagContents( $metas => $meta_tags_ref );
}

sub addTransition {
				my $self = shift;
				my $transitions_ref = $self->getContentObjectByName( $transitions );
				if( !( $transitions_ref && @$transitions_ref ) ) {
								$transitions_ref = [];
				}

				my $transition = new SMIL::Transition( @_ );
				push @$transitions_ref, $transition;
#				$self->{ $transitions } = $transitions_ref;
				$self->setTagContents( $transitions => $transitions_ref );
}

sub addRegion {
    my $self = shift;
    $self->{$layout} = new SMIL::Layout( @_ )
								unless $self->getContentObjectByName( $layout );
    $self->getContentObjectByName( $layout )->addRegion( @_ );
}

my $switch = 'switch';
my $layouts = 'layouts';

sub setSwitchedLayout {
    my $self = shift;
    my %hash = @_;
    
    # Extract the switch attribute
    my $switch_attribute = $hash{ $switch };
    my $thelayout = $hash{ $layouts };
    
    my $switch_obj = new SMIL::Switch( $switch_attribute, $thelayout );
    $self->setTagContents( $layout => $switch_obj );
}