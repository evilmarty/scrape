require "test_helper"

class ScrapeTest < Scrape::TestCase
  test "#user_agent should return default when not set" do
    assert_equal Scrape.user_agent, "Scrape/#{Scrape::VERSION}"
  end

  test "#load_scrapefile should return a new application" do
    app = Scrape.load_scrapefile '.'
    assert_kind_of Scrape::Application, app
  end

  test "#open should send a request to the specified url and return the contents" do
    stub_request(:get, "http://example.com/").to_return(:status => 200, :body => "booyah")
    assert_equal "booyah", Scrape.open("http://example.com")
  end

  test "#open should set the user agent in the request header" do
    stub_request(:get, "http://example.com/").
      with(:headers => {"User-Agent" => "Scrape/#{Scrape::VERSION}"}).
      to_return(:status => 200, :body => "")
    Scrape.open("http://example.com")
    assert true
  end
end