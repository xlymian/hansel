require "rubygems"
require 'spec'
require 'lib/hansel'

module Helpers
end

Spec::Runner.configure do |config|
  config.include Helpers
end
