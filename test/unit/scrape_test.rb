require "test_helper"

class ScrapeTest < Scrape::TestCase
  test ".user_agent should return default when not set" do
    assert_equal Scrape.user_agent, "Scrape/#{Scrape::VERSION}"
  end

  test ".load_scrapefile should return a new application" do
    app = Scrape.load_scrapefile '.'
    assert_kind_of Scrape::Application, app
  end

  test ".open should set the user agent in the request header" do
    stub_request(:get, "http://example.com/").
      with(:headers => {"User-Agent" => "Scrape/#{Scrape::VERSION}"}).
      to_return(:status => 200, :body => "")
    Scrape.open("http://example.com")
    assert true
  end

  test ".open should redirect when response is indicates redirection" do
    stub_request(:get, "http://example.com/foo").
      to_return(:status => 301, :headers => {:location => "http://example.com/bar"})
    stub_request(:get, "http://example.com/bar").
      to_return(:status => 200, :body => "booyah")
    Scrape.open("http://example.com/foo")
    assert true
  end

  test ".open should raise error when not successful" do
    stub_request(:get, "http://example.com/").
      to_return(:status => 404, :body => "")

    assert_raises Scrape::HTTPError do
      Scrape.open("http://example.com")
    end
  end
end