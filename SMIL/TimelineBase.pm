package SMIL::TimelineBase;

$VERSION = "0.85";

require Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( @timelineAttributes );

@timelineAttributes = ( "id", "begin", "endsync", "end" );

