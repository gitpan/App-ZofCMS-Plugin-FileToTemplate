#!/usr/bin/env perl

use Test::More tests => 4;

BEGIN {
    use_ok('App::ZofCMS');
    use_ok('Data::Transformer');
    use_ok('File::Spec');
	use_ok( 'App::ZofCMS::Plugin::FileToTemplate' );
}

diag( "Testing App::ZofCMS::Plugin::FileToTemplate $App::ZofCMS::Plugin::FileToTemplate::VERSION, Perl $], $^X" );
