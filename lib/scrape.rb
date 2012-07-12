require "rubygems"
require "logger"
require "open-uri"
require "bundler/setup"

module Scrape
  require 'scrape/version'

  autoload 'Application', 'scrape/application'
  autoload 'Site', 'scrape/site'
  autoload 'Match', 'scrape/match'
  autoload 'DefaultLoader', 'scrape/default_loader'
  autoload 'DSL', 'scrape/dsl'
  autoload 'URI', 'scrape/uri'

  class FileNotFound < Exception; end

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

    def open url, headers = {}, &block
      headers = {"User-Agent" => user_agent}.merge(headers)
      super(url, headers, &block).read
    end
  end
end