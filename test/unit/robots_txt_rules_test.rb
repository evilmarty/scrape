require "test_helper"

class RobotsTxtRulesTest < Scrape::TestCase
  test "#initialize should set the rules passed as multiple arguments" do
    rules = Scrape::RobotsTxtRules.new "/foo", "/bar"
    assert_equal ["/foo", "/bar"], rules.to_a
  end

  test "#initialize should set the rules passed an array argument" do
    rules = Scrape::RobotsTxtRules.new ["/foo", "/bar"]
    assert_equal ["/foo", "/bar"], rules.to_a
  end

  test "#<< should append the string" do
    rules = Scrape::RobotsTxtRules.new "/foo"
    assert_equal ["/foo"], rules.to_a
    rules << "/bar"
    assert_equal ["/foo", "/bar"], rules.to_a
  end

  test "#<< should append the array" do
    rules = Scrape::RobotsTxtRules.new "/foo"
    assert_equal ["/foo"], rules.to_a
    rules << ["/bar", "/too"]
    assert_equal ["/foo", "/bar", "/too"], rules.to_a
  end

  test "#+ should return a new instance concatenating it self and the given array" do
    rules1 = Scrape::RobotsTxtRules.new "/foo"
    rules2 = rules1 + ["/bar"]
    refute_equal rules1, rules2
    assert_kind_of Scrape::RobotsTxtRules, rules2
    assert_equal ["/foo", "/bar"], rules2.to_a
  end

  test "#=~ should match anything that beings with /" do
    rules = Scrape::RobotsTxtRules.new "/"
    assert rules =~ "/"
    assert rules =~ "/foo"
  end

  test "#=~ should match anything that begins with rules" do
    rules = Scrape::RobotsTxtRules.new "/foo"
    assert rules =~ "/foo"
    assert rules =~ "/foo/"
    assert rules =~ "/foo/bar"
    assert rules =~ "/foo.html"
    refute rules =~ "/bar"
  end
end