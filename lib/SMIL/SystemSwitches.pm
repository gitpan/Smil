package SMIL::SystemSwitches;

$VERSION = "0.891";

require Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( @systemSwitchAttributes );

@systemSwitchAttributes = ( "system-bitrate", 
			    "system-required", 
#			    "cv:systemComponent",
			    "system-language" );

