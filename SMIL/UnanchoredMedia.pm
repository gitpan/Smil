package SMIL::UnanchoredMedia;

$VERSION = "0.701";

use SMIL::XMLTag;
use SMIL::MediaAttributes;

@ISA = qw( SMIL::XMLTag );

my $media_type = 'type';
my $INLINE = 'inline';

my %typeLookupHash = (
	'rt' => 'text/vnd.rn-realtext',
	'rp' => 'image/vnd.rn-realpix',
	'swf' => 'image/vnd.rn-realflash',
	'gif' => 'image/gif',
	'jpg' => 'image/jpeg',
	'jpeg' => 'image/jpeg',
	'rm' => 'audio/vnd.rn-realvideo',
	'ra' => 'audio/vnd.rn-realvideo',
	'txt' => 'text/plain',
	'html' => 'text/html',
	'htm' => 'text/html'
);

sub init {
    my $self = shift;
    my %hash = @_;
    
    my $type = $hash{ $media_type } unless $hash{ $media_type } =~ /.\/./;
    $self->SUPER::init( $type ? $type : "ref" );

    if( $hash{ $INLINE } ) {
        $self->{_inline} = 1;
    }

    my %attrs = $self->createValidAttributes( { %hash },
					     [@mediaAttributes] );
    
    $self->setAttributes( %attrs );
    $self->setFavorite( "src" );
}

sub lookupType {
	my $filename = shift;
	# get filename extension
	$extension = $1 if $filename =~ /\.(.*?)$/;
	
	# Lowercase it
	$extension = "\L$extension";

	return $typeLookupHash{ $extension };
}

sub resolveTypeFromUrl {

	my $type = "";
	my $url = shift;

	@results = &LWP::Simple::head( $url );
	$type = $results[ 0 ];	

	return $type;

}

sub getContent {
	my $self = shift;
	
	eval 'use LWP::Simple;';
	my $lwpInstalled = !$@;

	my $content = "";
	my $type = "";
	my $thisSrc = $self->getAttribute( "src" );

	if( $thisSrc ) {
		if( $thisSrc =~ /^http:/ and $lwpInstalled ) {
			$content = &LWP::Simple::get( $thisSrc );	
			$type = &resolveTypeFromUrl( $thisSrc );
		}
		elsif( $thisSrc !~ /^http:/ ) {
			# Assume it comes from disk
			if( open CONTENT, $thisSrc ) {
				binmode CONTENT;
				undef $/;
				$content = <CONTENT>;
			}
			
			# Lookup the type based on filename
			$type = &lookupType( $thisSrc );
		}
	}
	return( $content, $type );
}

sub getAsString {

   my $self = shift;
   my $content =  "";

   if( $self->{_inline} ) {
   	eval 'use MIME::Base64';
	my $canEncode = !$@; 

	if( $canEncode ) {
		# OK, download the media, or whatever and Base64 encode it.
		my( $content, $type ) = $self->getContent;

		# encode it
		$content = &encode_base64( $content );
		chomp $content;
	
		if( $content ) {
			# tack on the type
			$content = "data:$type;base64,$content";

			$self->setAttribute( "src" => $content );
		}
	}
   }

   return $self->SUPER::getAsString;
}

1;
