package SMIL::SystemSwitches;

$VERSION = "0.86";

require Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( @systemSwitchAttributes );

@systemSwitchAttributes = ( "system-bitrate", 
			    "system-required", 
#			    "cv:systemComponent",
			    "system-language" );

