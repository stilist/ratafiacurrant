# Ratafia Currant

A repository for everything I write or make for use with my blog (excepting
images).

## Contents

The `themes` directory holds a few Tumblr themes I’ve made.

The `entries` directory holds most of the stuff I’ve written for my blog. The
formatting is in [Markdown][mdown], but with a few additional bits that match
my way of doing things. At the moment nothing actually _uses_ the extra stuff,
but it’s a platform-independent way of storing it in case I want to move on
to a different publishing system.

The entries are organized into a subdirectory structure that follows the format
`%Y/%M/%d/<entry name>.mdown` (in [MySQL parlance][msdate]).

 [msdate]: http://dev.mysql.com/doc/refman/5.1/en/date-and-time-functions.html#function_date-format

### Metadata tags

At the moment, there are four metadata tags that can appear
at the start of an entry: `BOOKMARK`, `LINK`, `PUBLISHED`, and `TAGS`; they are
followed by a colon, a single space, and a single line of data.

 [mdown]: http://daringfireball.net/projects/markdown/

`BOOKMARK` refers to an external (to the blog) bookmark site (such as
delicious), and provides the destination service’s unique address (such as
delicious’ hash lookup). I have a pretty well-developed bookmarking system
that’s very helpful for finding things, so it’s convenient to have the lookup
available. The field is only included with link articles, but isn’t guaranteed
to be accompany the `LINK` tag. Speaking of which…

`LINK`: Only appears when the entry is a link to an external address. These
entries are rendered in the linking style used by Tumblr and Daring Fireball
(meaning that the article title serves as a link to the targeted URL).

`PUBLISHED`: Date and time first published. Because I’m currently based in
Tumblr, this takes the form `%b %D, %Y %l:%i%p` (again, using MySQL’s
`DATE_FORMAT` as a reference).

And, finally, `TAGS`. This is simply a list of terms associated with the entry,
separated by a comma and a space.

## Of course…

Everything mentioned here is subject to change, but I feel the format is fairly
stable.
