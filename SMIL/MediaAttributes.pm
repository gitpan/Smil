package SMIL::MediaAttributes;

use SMIL::SystemSwitches;

$VERSION = "0.861";

require Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( @mediaAttributes @timeAtts );

@timeAtts = ( "begin", "end", "clip-end", "start", "dur", "clip-begin", );
@mediaAttributes = ( @timeAtts, @systemSwitchAttributes,
		     "fill", "src", "region", "id", "transition" );

