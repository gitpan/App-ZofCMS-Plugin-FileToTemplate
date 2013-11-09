package App::ZofCMS::Plugin::FileToTemplate;

use warnings;
use strict;

our $VERSION = '0.0102';

use Data::Transformer;
use File::Spec;

sub new { bless {}, shift }

my $Template_Dir;

sub process {
    my ( $self, $template, $query, $config ) = @_;

    $Template_Dir = $config->conf->{templates};

    my $t = Data::Transformer->new( normal => \&callback );
    $t->traverse( $template );
}

sub callback {
    my $in = shift;

    while ( my ( $t  ) = $$in =~ /<FTTR:([^>]+)>/ ) {
        my $tag_result;
        my $file = File::Spec->catfile( $Template_Dir, $t );
        if ( open my $fh, '<', $file ) {
            $tag_result = do { local $/; <$fh>; };
        }
        else {
            $tag_result = $!;
        }
        $$in =~ s/<FTTR:[^>]+>/$tag_result/;
    }

    if ( my ( $t  ) = $$in =~ /<FTTD:([^>]+)>/ ) {
        my $tag_result;
        my $file = File::Spec->catfile( $Template_Dir, $t );

        $tag_result = do $file
            or $tag_result = "ERROR: $! $@";

        $$in = $tag_result;
    }
}

1;
__END__

=encoding utf8

=head1 NAME

App::ZofCMS::Plugin::FileToTemplate - read or do() files into ZofCMS Templates

=head1 SYNOPSIS

In your ZofCMS Template:

    plugins => [ qw/FileToTemplate/ ],
    t  => {
        foo => '<FTTR:index.tmpl>',
    },

In you L<HTML::Template> template:

    <tmpl_var escape='html' name='foo'>

=head1 DESCRIPTION

The module is a plugin for L<App::ZofCMS>; it provides functionality to either read (slurp)
or C<do()> files and stick them in place of "tags".. read on to understand more.

This documentation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config> and
L<App::ZofCMS::Template>

=head1 ADDING THE PLUGIN

    plugins => [ qw/FileToTemplate/ ],

Unlike many other plugins to run this plugin you barely need to include it in the list of
plugins to execute.

=head1 TAGS

    t  => {
        foo => '<FTTR:index.tmpl>',
        bar => '<FTTD:index.tmpl>',
    },

Anywhere in your ZofCMS template you can use two "tags" that this plugin provides. Those
"tags" will be replaced - depending on the type of tag - with either the contents of the file
or the last value returned by the file.

Both tags are in format: opening angle bracket, name of the tag in capital letters, semicolon,
filename, closing angle bracket. The filename is relative to your "templates" directory, i.e.
the directory referenced by C<templates> key in Main Config file.

=head2 C<< <FTTR:filename> >>

    t  => {
        foo => '<FTTR:index.tmpl>',
    },

The C<< <FTTR:filename> >> reads (slurps) the contents of the file and tag is replaced
with those contents. You can have several of these tags as values. Be careful reading in
large files with this tag. Mnemonic: B<F>ile B<T>o B<T>emplate B<R>ead.

=head2 C<< <FTTD:filename> >>

    t => {
        foo => '<FTTD:index.tmpl>',
    },

The C<< <FTTD:filename> >> tag will C<do()> your file and the last returned value will be
assigned to the B<value in which the tag appears>, in other words, having
C<< foo => '<FTTD:index.tmpl>', >> and C<< foo => '<FTTD:index.tmpl> blah blah blah', >>
is the same. Using this tag, for example, you can add large hashrefs or config hashrefs
into your templates without clobbering them. Note that if the C<do()> cannot find your file
or compilation of the file fails, the value with the tag will be replaced by the error message.
Mnemomic: B<F>ile B<T>o B<T>emplate B<D>o.

=head1 NON-CORE PREREQUISITES

The plugin requires one non-core module: L<Data::Transformer>

=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://zoffix.com/>, L<http://haslayout.net/>, L<http://zofdesign.com/>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-plugin-filetotemplate at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-Plugin-FileToTemplate>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::Plugin::FileToTemplate

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-Plugin-FileToTemplate>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-Plugin-FileToTemplate>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-Plugin-FileToTemplate>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-Plugin-FileToTemplate>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 'Zoffix, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

