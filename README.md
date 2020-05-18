# NicFitMTG.com

This is the source behind the website https://nicfitmtg.com.


## Site details

The site is built as a static site using [Jekyll](https://jekyllrb.com)
and hosted for free by [GitHub pages](https://pages.github.com/).
The site is automatically built and updated when there are commits on the master branch
although it can take up to 5 minutes.


### Running the site locally

You can build the site HTML and serve it locally with:

    bundle exec jekyll serve
    # This starts a local webserver at http://localhost:4000

To build the JavaScript and CSS which is only necessary if you want to work on design, use:

    npm install
    npm run build  # Use watch instead of build to continuously build it


## Contributing

If you're interested in contributing non-trivial updates or content to the site,
probably the best first step is to introduce yourself in the [NicFit Discord](https://discordapp.com/invite/5R6KBa5)
in the `#flashback-therapy` channel. That's the usual place where discussion about the site takes place.


### Contributing content

Contributing content is always welcome.
The site is generally broken up into pages that change somewhat infrequently like deck archetypes (see `_pages/archetypes*`)
and more time-sensitive posts (see `_posts/*`) like meta-specific sideboard guides, tournament reports, new set overviews, and interviews.

Here's some great areas to contribute:

- Tournament reports: if Nic Fit places near the top in the big tournament, we should write about it
  and hopefully get the pilot to do a quick interview
- Videos: I'd love to have more videos of Nic Fit on camera at big paper tournaments
- The archetypes pages could use always use a bit more depth


### Contributing to design

The layout and design of the site could absolutely use work.
Improvements here are welcome!


### Contributing to code

There's not a ton of custom code for the site, but there's some in the plugins (`_plugins`)
to allow easy linking to cards and showing images of cards.
Improvements here are welcome!


## Credits

NicFitMTG is unofficial Fan Content permitted under the [Wizards of the Coast Fan Content Policy][].

NicFitMTG uses card imagery provided by [Scryfall][] in accordance with their [image guidelines][]
and [bulk data][] to have accurate and up-to-date card information.

[Wizards of the Coast Fan Content Policy]: https://company.wizards.com/fancontentpolicy
[Scryfall]: https://scryfall.com/
[image guidelines]: https://scryfall.com/docs/api/images
[bulk data]: https://scryfall.com/docs/api/bulk-data
