package Smil;

$VERSION = "0.70";

use Carp;
use SMIL::XMLBase;
use SMIL::XMLContainer;
use SMIL::XMLTag;
use SMIL::Head;
use SMIL::Body;
my $TRUE = 'true';

@ISA = qw( SMIL::XMLContainer );

my $head = "head";
my $body = "body";
my @timelineStack;
my $smil;
my $file = "file";

my $QT_EXTENSIONS = 'qt-extensions';
my $QT_SHORT = 'qt';
my $QT_NS_URL = "http://www.apple.com/quicktime/resources/smilextensions";
my $QT_NS = "xmlns:qt";

my $QT_AUTOPLAY = "qt:autoplay";
my $QT_CHAPTER_MODE = "qt:chapter-mode";
my $QT_IMMEDIATE_INSTANTIATION = "qt:immediate-instantiation";
my $QT_NEXT = "qt:next";
my $QT_TIME_SLIDER = "qt:time-slider";

my $RN_CV = "xmlns:cv";

my @smilAttributes = ( $RN_CV,
$QT_AUTOPLAY,
$QT_CHAPTER_MODE,
$QT_IMMEDIATE_INSTANTIATION,
$QT_NEXT,
$QT_TIME_SLIDER );

sub init {
    my $self = shift;
    $self->SUPER::init( "smil" );

    my %hash = @_;
    my %smilAttrs = $self->createValidAttributes( { %hash },
						  [ @smilAttributes ] );

    if( $hash{ $QT_SHORT } or 
	$hash{ $QT_EXTENSIONS } ) {
         $smilAttrs{ $QT_NS } = $QT_NS_URL;
	$favorite = $QT_NS;
    }

    if( $hash{ RN_CV } ) {
	
    }

    $self->setAttributes( %smilAttrs );
    
    $self->setFavorite( $favorite ) if $favorite;
    $self->initHead( @_ );
    $self->initBody( @_ );
    $self->initFile( @_ );
}

sub setQtAutoplay {
	my $self = shift;
	$self->setAttribute( $QT_AUTOPLAY => $TRUE );
	$self->useQtExtensions;
}

sub setQtChapterMode {
	my $self = shift;
	my $dur = shift;
	$self->setAttribute( $QT_CHAPTER_MODE => $dur );
	$self->useQtExtensions;
}

sub useQtImmediateInstantiation {
	my $self = shift;
	$self->setAttribute( $QT_IMMEDIATE_INSTANTIATION => $TRUE );
	$self->useQtExtensions;
}

sub setQtNextPresentation {
	$self = shift;
	$next = shift;
	$self->setAttribute( $QT_NEXT => $next );
	$self->useQtExtensions;
}

sub useQtTimeSlider {
	$self = shift;
	$self->setAttribute( $QT_TIME_SLIDER => $TRUE );
	$self->useQtExtensions;
}

sub useQtExtensions {
	my $self = shift;
	$self->setAttribute( $QT_NS => $QT_NS_URL );
	$self->setFavorite( $QT_NS );
}

sub getRootHeight {
    my $self = shift;
    my $hd = $self->getContentObjectByName( $head );
    return $hd ? $hd->getRootHeight() : 0;
}

sub getRootWidth {
    my $self = shift;
    my $hd = $self->getContentObjectByName( $head );
    return $hd ? $hd->getRootWidth() : 0;
}

sub getAsString {
    my $self = shift;

#    croak "Need to make sure to match start with end when defining timeline"
#	if( $check_errors && @{$self->{$timelineStack}} );

    return $self->SUPER::getAsString();
}

sub initFile {
    my $self = shift;
    my %hash = @_;
    if( $hash{ $file } ) {
	$self->{$file} = $hash{ $file };
    }
}

sub initHead {
    my $self = shift;
    my %hash = @_;
    $self->setTagContents( $head => new SMIL::Head( @_ ) )
	if( ( $hash{ 'height' } && $hash{ 'width' } ) ||
	    $hash{ 'meta' } );
}

sub initBody {
    my $self = shift;
    $self->setTagContents( $body => new SMIL::Body( @_ ) ) unless $self->{$body};
}

sub startSequence {
    my $self = shift;
    $self->getContentObjectByName( $body )->startSequence( @_ );
}

sub startParallel {
    my $self = shift;
    $self->getContentObjectByName( $body )->startParallel( @_ );
}

sub endParallel {
    my $self = shift;
    $self->getContentObjectByName( $body )->endParallel();
}

sub endSequence {
    my $self = shift;
    $self->getContentObjectByName( $body )->endSequence();
}

sub hasQtExtensions {

   my $self = shift;
   my %hash = @_;
   my $returnValue = 0;

   foreach my $item ( keys %hash ) {
	$returnValue = 1 if $item =~ /^qt:/;
   }

   return $returnValue;
}

sub addMedia {
    my $self = shift;

    # Check for QT extensions, and add if necessary
    if( $self->hasQtExtensions( @_ ) ) {
	$self->useQtExtensions;
    }

    $self->getContentObjectByName( $body )->addMedia( @_ );
}

sub addCode {
    my $self = shift;
    $self->getContentObjectByName( $body )->addCode( @_ );
}

sub addComment {
    my $self = shift;
    my $comment = shift;
    $self->getContentObjectByName( $body )->addCode( "<!--$comment-->" );
}

sub addSwitchedMedia {
    my $self = shift;
    $self->getContentObjectByName( $body )->addSwitchedMedia( @_ );
}

# Can only have one layout, so "set" rather than "add"
sub setSwitchedLayout {
    my $self = shift;
    if( $self->{$head} ) {
	$self->setTagContents( $head => new SMIL::Head( @_ ) );
    }
    $self->getContentObjectByName( $head )->setSwitchedLayout( @_ );
}

sub header {
    return "Content-type: application/smil\n\n";
}

sub setMeta {
    my $self = shift;
    croak "Setting meta for SMIL NYI.";
}

sub setLayout {
    my $self = shift;
    croak "SetLayout for SMIL NYI.";
}

sub addRegion {
    my $self = shift;
    $self->getContentObjectByName( $head )->addRegion( @_ );
}

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Smil.pm - Perl extension for dynamic generation of SMIL files.

=head1 SYNOPSIS

  use Smil;
  (read on, good knight...)

=head1 DESCRIPTION

This module provides an object oriented interface to generation of 
SMIL (Synchronized Multimedia Integration Language) files.  Creating
a simple SMIL file is as simple as this script:

    use Smil;
$s = new Smil;
print $s->header; # Remember MIME header if running as CGI
$s->addMedia( "src" => "rtsp://videoserver.com/video.rm" );
print $s->getAsString();

This will create the following SMIL file with the correct header, perfect
for a CGI script coming off a web server:

 Content-type: application/smil

 <smil>
    <body>
        <par>
            <ref src="rtsp://videoserver.com/video.rm"/>
        </par>
    </body>
 </smil>

Your first SMIL file!  Actually, this doesn't do much, but SMIL beginners 
can't be choosers, right?

As a new feature as of 0.70, you can now use Quicktime extensions.  Peruse the qt.pl file
in the installation directory for a sampling of the methods you can call for Quicktime
extensions added to the <smil> element.  Otherwise, add the attributes and their 
values directly into SMIL when you call addMedia.  Smil.pm will allow any namespace
attributes to pass through to the media element.  When you do add one of these attributes,
or call something like setQtAutoplay(), Smil.pm automatically adds the xmlns:qt attribute
with the proper unique identifier to the <smil> element.  So, if you decide midway through
creation of a SMIL file that you want Quicktime extensions, call the proper method and
Smil.pm will add the proper code to add these extensions to your SMIL file.

You can do more advanced things by adding regions to your SMIL files, and
playing media inside those regions.

    $s = new Smil( "height" => 300, "width" => 300 );
    $region_name = "first_region";
    $s->addRegion( "name" => $region_name, 
		   "top" => 20, "left" => 35, 
		   "height" => 100, "width" => 100 );
    $s->addMedia( "src" => "rtsp://videoserver.com/video.rm",
              "region" => $region_name );
    print $s->getAsString;

This code results in the following output:

 <smil>
    <head>
        <layout>
            <root-layout width="300" 
                         height="300"/>
            <region width="100" 
                    height="100" 
                    left="35" 
                    top="20" 
                    id="first_region"/>
        </layout>
    </head>
    <body>
        <par>
            <ref src="rtsp://videoserver.com/video.rm" 
                 region="first_region"/>
        </par>
    </body>
 </smil>

(Well, sort of, I had to reformat it so that it didn't stretch past the
end of the line, but functionally exactly the same)

All of this would be somewhat trivial if this module didn't expose the 
main differentiator between SMIL and HTML -- the timeline!  With SMIL
you can synchronize and schedule your media over a timeline, all 
without nasty proprietary scripting solutions.  This idea is built into 
SMIL and exposed in this module.

 $s = new Smil( "height" => 300, "width" => 300 );
 $region1 = "first_region";
 $region2 = "second_region";
 $s->addRegion( "name" => $region1, 
		"top" => 20, "left" => 35, 
		"height" => 100, "width" => 100 );
 $s->addRegion( "name" => $region2, 
		"top" => 60, "left" => 55, 
		"height" => 120, "width" => 120 );
 $s->startSequence();
 $s->addMedia( "src" => "rtsp://videoserver.com/video1.rm",
	       "region" => $region1 );
 $s->addMedia( "src" => "rtsp://videoserver.com/video2.rm",
	       "region" => $region2 );
 $s->endSequence();
 print $s->getAsString;

Results in this (again formatted to fit your screen...)

 <smil>
    <head>
        <layout>
            <root-layout width="300" height="300"/>
            <region width="100" height="100" 
                    left="35" top="20" 
                    id="first_region"/>
            <region width="120" height="120" 
                    left="55" top="60" 
                    id="second_region"/>
        </layout>
    </head>
    <body>
        <seq>
            <ref src="rtsp://videoserver.com/video1.rm" 
                    region="first_region"/>
            <ref src="rtsp://videoserver.com/video2.rm" 
                    region="second_region"/>
        </seq>
    </body>
 </smil>

You can schedule media in two ways, by calling startSequence coupled with 
endSequence or startParallel with endParallel, as you saw above, 
or you can specify begin and end times within the media directly for 
an absolute timeline.  

 $s = new Smil( "height" => 300, "width" => 300 );
 $region1 = "first_region";
 $region2 = "second_region";
 $s->addRegion( "name" => $region1, 
		"top" => 20, "left" => 35, 
		"height" => 100, "width" => 100 );
 $s->addRegion( "name" => $region2, 
		"top" => 60, "left" => 55, 
		"height" => 120, "width" => 120 );
 $s->startParallel();
 $s->addMedia( "src" => "rtsp://videoserver.com/video1.rm",
	       "region" => $region1 );
 $s->addMedia( "src" => "rtsp://videoserver.com/video1.rm",
	       "region" => $region2,
	       "begin" => "5s" );
 $s->endParallel();
 print $s->getAsString();

Producing this:

 <smil>
    <head>
        <layout>
            <root-layout width="300" height="300"/>
            <region width="100" height="100" 
                    left="35" top="20" id="first_region"/>
            <region width="120" height="120" 
                    left="55" top="60" id="second_region"/>
        </layout>
    </head>
    <body>
        <par>
            <ref src="rtsp://videoserver.com/video1.rm" 
                 region="first_region"/>
            <ref src="rtsp://videoserver.com/video1.rm" 
                 region="second_region" begin="5s"/>
        </par>
    </body>
 </smil>

Notice the "begin" parameter, this tells the media its absolute begin time.
The above code will start the second clip 5 seconds after the first even
though they are playing in parallel

You can add your own code using the addCode method

    $s->addCode( "<new_tag/>" );

You can add comments by using the addComment method

    $s->addComment( "A comment is here" );

PerlySMIL will add the necessary comment code around the comment, so you 
get back

<!--A comment is here-->

You as the author are responsible for formatting, so don't expect that
your arbitrary code will be indented like the rest of the SMIL.

Like HTML, SMIL applications can have hyperlinks.  There are two types in 
SMIL: normal hrefs, and anchors.  An href covers the entire media item, 
whereas an anchor covers a rectangular portion of the media item.  To create
an href, add the "href" parameter when you add the media to the 
SMIL object.

 $s->addMedia( "src" => "rtsp://videosource.com/video.rm",
               "show" => "new",
               "href" => "http://www.destinationlink.com/link.html" );

Adding anchors is more complex, but much more versatile.  You can do 
everything with anchors that you can do with hrefs, but with anchors
you add the capability to change the hyperlinks over time and specify
only portions of the media item for linking.  To create an anchor
you need to pass, brace yourself, a reference to an array of hash references.
Mimic the code below if you don't want to know what that means.  The format 
is like this:

[ { hash_values }, { hash_values } ] where hash_values are key-value
pairs like "bob" => "sally"  (Perl gurus know that "=>" is a synonym for
comma...)

Here's a code example to get you started.

    $smil->addMedia( 'src' => "video.rm",
		     'anchors' => 
                        [ 
                          { 'href' => "http://websrv.com/index.html, 
                              'coords' => '0,0,110,50',
			      'show' => 'new',
			      'begin' => 3 } ,
                          { 'href' => "another.smil",
			      'coords' => '125,208,185,245',
			      'begin' => 9 } 
                        ] );

Notice several things about the above example.  One, with an anchor, we
can specify where we want the hyperlink to persist over the media item.  
This is done using a coordinate system with two points, the top, left 
corner, and the bottom, right corner.  So, if we wanted to remove the 
href tag completely, we could just specify the entire canvas of the media
item in the coordinate parameter and we would have the same thing as a href.
Also, in the above example, we started some hyperlinks at different times.
The first one begins a 3 seconds, and the second begins at 9 seconds.  We
could have also specified end times using the "end" parameter/attribute.
Finally, since a SMIL is not HTML we have to have a mechanism for dealing
with links to HTML files (or other media for that matter) and media that
can play back within our SMIL player.  So, if we want to send the result
of clicking on a link to a web browser, we need to use the "show" parameter
and give it a value of "new".  If we want our SMIL player to handle the
hyperlink itself (as would be the case for the second example since it is
another smil file), we can either leave the "show" parameter out and let 
it default to the SMIL player, or explicitly add "show" => "replace" to
replace the current SMIL file with the new link.

As a new feature of 0.7, you can now inline your media files directly within 
a SMIL file.  When you add media to smil using the addMedia method call, 
specify --inline => 1 and the module will attempt to download or read from
local disk any files which are added using this attribute.  Check out the 
inline.pl file inside the installation directory, and also the slurp.pl 
script which will slurp in simple SMIL files and inline all code if you give
it the proper parameter.

=head1 AUTHOR

Chris Dawson (cdawson@webiphany.com)
http://www.webiphany.com/perlysmil/

=head1 SEE ALSO

perl(1). perldoc CGI

=cut
