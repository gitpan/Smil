#!/usr/bin/perl
use lib '.';
use Smil;

$s = new Smil;
$s->setBackwardsCompatible( "player" => "rp", "version" => 6 );
$s->addMedia( src => "foo.gif", inline => 1, href => "http://www.real.com/" );
print $s->getAsString . "\n";
