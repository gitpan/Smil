package SMIL::TimelineBase;

$VERSION = "0.861";

require Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( @timelineAttributes );

@timelineAttributes = ( "id", "begin", "endsync", "end", "repeat" );

