package SMIL::Media;

$VERSION = "0.701";

use SMIL::XMLTag;

my @mediaAttributes = ( "begin", "end", "clip-end", "clip-begin", 
		       "start", "fill", "src", "region", "id", "dur" );

@ISA = qw( SMIL::XMLTag );

my $type = "type";
my $INLINE = 'inline';

sub init {
    my $self = shift;
    my %hash = @_;
    
    my $tag = $hash{ $type } and $hash{ $type } !~ /.\/./ ? $hash{ $type } : "ref";
    $self->SUPER::init( $tag );

    if( $hash{ $INLINE } ) {
	print "Setting inline\n";
	$self->{_inline} = 1;
    }

    my %mediaAttrs = $self->createValidAttributes( { %hash }, 
						  [ @mediaAttributes ] );
    $self->setAttributes( %mediaAttrs );

   $self->setFavorite( "src" );
}

sub getContent {
	my $self = shift;
	
	eval 'use LWP::Simple;';
	my $lwpInstalled = !$@;

	my $content = "";
	my $thisSrc = $self->getAttribute( "src" );

	if( $thisSrc ) {
		my $content = "";

		if( $thisSrc =~ /^http:/ and $lwpInstalled ) {
			$content = get $thisSrc;	
		}
		elsif( $thisSrc !~ /^http:/ ) {
			# Assume it comes from disk
			if( open CONTENT, $thisSrc ) {
				binmode CONTENT;
				while( <CONTENT> ) {
					$content .= $_;
				}
			}
		}
	}
	return $content;
}

sub getAsString {

   my $self = shift;
   my $returnString = "";
   my $notInline = 0;

	print "Getting as string\n";

   if( !$self->{_inline} ) {
	$notInline = 1;
   }
   if( $self->{_inline} ) {
   	eval 'use MIME::Base64';
	my $canEncode = !$@; 

	if( $canEncode ) {
		# OK, download the media, or whatever and Base64 encode it.
		my( $returnString, $type ) = $self->getContent;

		# encode it
		$returnString = &encode_base64( $returnString );
	
		# tack on the type
		$returnString = "data:$type;base64,$content";
	}
	else {
		$notInline = 1;
	}
   }

   if( $notInline ) {
	$returnString = $self->SUPER::getAsString;
   }

   return $returnString;

}
