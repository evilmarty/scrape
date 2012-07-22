$: << File.expand_path('../../lib', __FILE__)

require "minitest/autorun"
require "webmock/minitest"

require "bundler/setup"
Bundler.setup(:default, :test)

require "scrape"

# surpress log messages while we're testing
Scrape.logger = Class.new{ def method_missing name, *args; end }.new

class Scrape::TestCase < MiniTest::Unit::TestCase
  class << self
    def test name, &block
      method_name = name.gsub /[^a-z0-9_]+/i, '_'
      define_method "test_#{method_name}", &block
    end
    private :test
  end
end