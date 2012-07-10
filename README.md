# Scrape

A really simple web scraper.

```ruby
site "https://github.com/explore" # The site to scrape. Will be used as the base address.

match /evilmarty/ do |doc| # A regexp/string/proc to match against the current url.

  doc.search('a[href]') # The nokogiri document of the contents of the current url.

end

site "http://www.tumblr.com" # Can define multiple sites

match "/tagged" do |doc|
  # Do what ever we want with the document.
end
```

## Usage

After creating a `Scrapefile` simple run:

```
scrape -f [FILE]
```

If no scapefile is specified then `Scrapefile` is used by default.

## Installation

Simply install the gem

```
gem install scrape
```

## TODO

* Fix bugs
* Add support for Robots.txt
* Depth limiting
* Better docs
