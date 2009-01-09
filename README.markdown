# Ratafia Currant

An repository for everything I write or make for use with my blog.

## Contents

The `themes` directory holds a few Tumblr themes I’ve made.

The `entries` directory holds most of the stuff I’ve written for my blog. The
formatting is in [Markdown][mdown], but with a few additional bits that match
my way of doing things.

The entries are organized into a subdirectory structure that follows the format
`<four-digit year>/<full month in English>/<zero-led date>/<entry name>.mdown`

### Metadata tags

At the moment, there are three metadata tags that can appear
at the start of an entry: `BOOKMARK`, `LINK`, and `TAGS`; they are followed
by a colon, a single space, and a single line of data.

 [mdown]: http://daringfireball.net/projects/markdown/

`BOOKMARK` refers to an external (to the blog) bookmark site (such as
delicious), and provides the destination service’s unique address (such as
delicious’ hash lookup). I have a pretty well-developed bookmarking system
that’s very helpful for finding things, so it’s convenient to have the lookup
available. The field is only included with link articles, but isn’t guaranteed
to be accompany the `LINK` tag. Speaking of which…

`LINK`: Only appears when the entry is a link to an external address. These
entries are rendered in the linking style used by Tumblr and Daring Fireball
(meaning that the article title serves as a link to the targetted URL).

And, finally, `TAGS`. This is simply a comma-separated list of tags associated
with the entry.

## Of course…

Everything mentioned here is subject to change, but I think the layout is
general enough that there shouldn’t be much need for wild restructuring.
