use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::ZofCMS::Plugin::FileToTemplate',
    license             => 'perl',
    dist_author         => q|Zoffix <'zoffix@cpan.org'>|,
    dist_version_from   => 'lib/App/ZofCMS/Plugin/FileToTemplate.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'App::ZofCMS'       => 0.0106,
        'Data::Transformer' => 0.04,
        'File::Spec'        => 3.2701,
    },
    add_to_cleanup      => [ 'App-ZofCMS-Plugin-FileToTemplate-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
