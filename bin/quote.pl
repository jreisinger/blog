#!/usr/bin/perl
# Print a random quote and the image in HTML format.
# Usage:
#
# * * * * *   $HOME/blog/bin/quote.pl > $HOME/public_html/quote.html
use strict;
use warnings;
use LWP::Simple;
use CGI;

my $url =
  'https://raw.githubusercontent.com/jreisinger/blog/master/posts/quotes.txt';
my $doc = get $url;
exit unless $doc;

my @quotes = split /\n+/, $doc;
my $quote = $quotes[ rand @quotes ];

# -- TimToady (http://irclog.perlgeek.de/perl6/2013-07-21)
# ===>
# -- <a href="http://irclog.perlgeek.de/perl6/2013-07-21">TimToady</a>
$quote =~ s#--\s{0,3}([^(]+?)\s+\((http:\/\/[^)]+)\)#-- <a href="$2">$1</a>#;

my $q = CGI->new;

#<<<
binmode STDOUT, ':utf8';
print 
  $q->start_html( -title => "Quote of the Minute", -encoding => "utf-8" ),
  $q->p($quote),
  $q->img(
    {
        src => "http://imgs.xkcd.com/comics/lisp.jpg",
        title =>
          "We lost the documentation on quantum mechanics.  You'\''ll have to decode the regexes yourself.",
        alt => "Lisp"
    }
  ),
  $q->end_html;
#>>>
