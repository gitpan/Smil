package SMIL::TimelineBase;

$VERSION = "0.891";

require Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( @timelineAttributes );

@timelineAttributes = ( "id", "begin", "endsync", "end", "repeat" );

