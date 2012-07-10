require "test_helper"

class MatchTest < Scrape::TestCase
  test "#initialize should raise error when proc's arity isn't one" do
    assert_raises ArgumentError do
      Scrape::Match.new("test"){ "no arguments" }
    end
  end

  test "#invoke should call the proc" do
    ok = false
    match = Scrape::Match.new("test"){|doc| ok = true }
    match.invoke nil
    assert ok, "Proc was not called"
  end

  test "#invoke should pass the document to the proc" do
    doc = "yay"
    ok = false
    match = Scrape::Match.new("test"){|d| ok = (doc == d) }
    match.invoke doc
    assert ok, "Document was not passed into the proc"
  end

  test "#=~ should return true when contains string" do
    match = Scrape::Match.new("bar"){|doc|}
    assert match =~ "foobar", "Expected true"
  end

  test "#=~ should return false when doesn't contains string" do
    match = Scrape::Match.new("bar"){|doc|}
    refute match =~ "ponies", "Expected false"
  end

  test "#=~ should return true when matches regexp" do
    match = Scrape::Match.new(/bar/){|doc|}
    assert match =~ "foobar", "Expected true"
  end

  test "#=~ should return false when doesn't match regexp" do
    match = Scrape::Match.new(/bar/){|doc|}
    refute match =~ "ponies", "Expected false"
  end

  test "#=~ should return true when proc is truthy" do
    match = Scrape::Match.new(lambda{|url| true }){|doc|}
    assert match =~ "ponies", "Expected true"
  end

  test "#=~ should return false when proc is falsy" do
    match = Scrape::Match.new(lambda{|url| false }){|doc|}
    refute match =~ "ponies", "Expected false"
  end
end