# -*- encoding: utf-8 -*-
require File.expand_path("../lib/scrape/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "scrape"
  s.version     = Scrape::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marty Zalega"]
  s.email       = ["evilmarty@gmail.com"]
  s.homepage    = "http://github.com/evilmarty/scrape"
  s.summary     = %q{A really simple web scraper}
  s.description = %q{An easy to use utility to scrape websites using a DSL similar to rake.}

  s.rubyforge_project = "scrape"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f) }
  s.require_paths = ["lib", "lib/scrape"]

  s.add_development_dependency "nokogiri", "~> 1.5.5"
  s.add_development_dependency "addressable", "~> 2.2.8"
end