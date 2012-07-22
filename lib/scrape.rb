require "rubygems"
require "logger"
require "addressable/uri"
require "faraday"
require "faraday_middleware"

$: << File.dirname(__FILE__)

require "scrape/version"
require "scrape/core_ext/array"
require "scrape/core_ext/string"

module Scrape
  autoload 'Application', 'scrape/application'
  autoload 'Site', 'scrape/site'
  autoload 'Match', 'scrape/match'
  autoload 'DefaultLoader', 'scrape/default_loader'
  autoload 'DSL', 'scrape/dsl'
  autoload 'RobotsTxt', 'scrape/robots_txt'
  autoload 'RobotsTxtRules', 'scrape/robots_txt_rules'

  class FileNotFound < Exception; end
  class HTTPError < StandardError; end

  class << self
    attr_writer :user_agent

    def user_agent
      @user_agent || "Scrape/#{Scrape::VERSION}"
    end

    def logger
      @logger ||= Logger.new STDOUT
    end

    def logger= log
      @logger = log
    end

    def load_scrapefile path
      Application.new path
    end

    def open url, headers = nil, &block
      url = Addressable::URI.parse url
      headers ||= {}

      conn = Faraday.new :url => url.to_s do |faraday|
        faraday.response :follow_redirects, :cookies => :all, :limit => 3
        faraday.adapter Faraday.default_adapter
      end

      conn.headers[:user_agent] = user_agent

      res = conn.get url.request_uri do |req|
        headers.each{|key, val| req[key] = val }
      end

      if res.success?
        res.body
      else
        raise HTTPError, res.status
      end
    end
  end
end