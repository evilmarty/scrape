require "test_helper"

class URITest < Scrape::TestCase
  {fragment: "blah", host: "www.example.com", password: "secret", path: "/dot", query: "foo=bar", scheme: "http", user: "chuck", relative?: false, absolute?: true}.each do |method_name, value|
    test "##{method_name} should return value" do
      uri = Scrape::URI.new "http://chuck:secret@www.example.com/dot?foo=bar#blah"
      assert_equal value, uri.send(method_name)
    end
  end

  test "#open should return the contents at the url" do
    stub_request(:get, "http://www.example.com/").with(headers: {"User-Agent" => Scrape.user_agent}).to_return(status: 200, body: "Howdie")

    uri = Scrape::URI.new "http://www.example.com"
    assert_equal "Howdie", uri.open
  end

  test "#+ should return a URI with the specified path" do
    uri1 = Scrape::URI.new "http://www.example.com"
    uri2 = uri1 + "/bar"
    assert_equal "http://www.example.com/bar", uri2.to_s
  end

  test "#+ should return a URI overwriting with the specified path" do
    uri1 = Scrape::URI.new "http://www.example.com/foo"
    uri2 = uri1 + "/bar"
    assert_equal "http://www.example.com/bar", uri2.to_s
  end

  test "#+ should return a URI with the specified path appended" do
    uri1 = Scrape::URI.new "http://www.example.com/foo"
    uri2 = uri1 + "bar"
    assert_equal "http://www.example.com/foo/bar", uri2.to_s
  end

  test "#+ should return a URI from the absolute url" do
    uri1 = Scrape::URI.new "http://www.example.com/foo"
    uri2 = uri1 + "http://www.example.com/bar"
    assert_equal "http://www.example.com/bar", uri2.to_s
  end

  test "#+ should return a URI appended from the absolute url" do
    uri1 = Scrape::URI.new "http://www.example.com/foo"
    uri2 = uri1 + "http://www.example.com/foo/bar"
    assert_equal "http://www.example.com/foo/bar", uri2.to_s
  end

  test "#< should return true when specified url is greater" do
    uri1 = Scrape::URI.new "http://www.example.com/foo"
    assert uri1 < "http://www.example.com/foo/bar"
  end
end