require "rubygems"
require 'spec'

$:.unshift File.dirname(__FILE__) + "/../lib"

module Helpers
end

Spec::Runner.configure do |config|
  config.include Helpers
end
