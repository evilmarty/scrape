require "test_helper"

class DSLTest < Scrape::TestCase
  test "#site should add the url to the application" do
    app = Scrape::Application.new(".")
    dsl = Scrape::DSL.new app
    dsl.site "http://example.com"
    assert app.sites.member?("http://example.com")
  end

  test "#site should return the currently defined sites" do
    app = Scrape::Application.new(".")
    dsl = Scrape::DSL.new app
    sites = dsl.site "http://example.com"
    assert_equal "http://example.com", sites[0].to_s
    assert_equal sites, dsl.site
  end

  test "#site should pass the options to the site" do
    app = Scrape::Application.new(".")
    dsl = Scrape::DSL.new app
    dsl.site "http://example.com", :test => true
    assert_equal true, app.sites["http://example.com"].options[:test]
  end

  test "#match should create a match on the current sites" do
    app = Scrape::Application.new(".")
    dsl = Scrape::DSL.new app
    dsl.site "http://example.com"
    site = app.sites["http://example.com"]
    assert_empty site.matches
    dsl.match("test"){|*args|}
    refute_empty site.matches
  end

  test "#match should raise an error when no sites have been defined" do
    app = Scrape::Application.new(".")
    dsl = Scrape::DSL.new app
    assert_raises ArgumentError do
      dsl.match("test"){|*args|}
    end
  end

  test "#enqueue should add the specified urls to the queue" do
    app = Scrape::Application.new(".")
    dsl = Scrape::DSL.new app
    dsl.enqueue "http://example.com"
    assert_equal ["http://example.com"], app.queue
  end
end