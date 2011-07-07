$LOAD_PATH.unshift 'lib'
require 'hansel/version'

Gem::Specification.new do |s|
  s.name              = "hansel"
  s.version           = HanselCore::Version
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Ruby driver for httperf - automated load and performance testing."
  s.homepage          = "http://github.com/xlymian/hansel"
  s.email             = "paul.mylchreest@mac.com"
  s.authors           = [ "Paul Mylchreest" ]

  s.files             = %w( README.markdown Rakefile LICENSE HISTORY.md )
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("spec/**/*")
  s.files            += Dir.glob("templates/**/*")
  s.files            += Dir.glob("lib/tasks/**/*")
  s.executables       = [ "hansel" ]

  s.rdoc_options      = ["--charset=UTF-8"]

  s.description = <<-DESCRIPTION
    Hansel is a pure ruby driver for httperf for automated load and
    performance testing. It will load a job queue file, in a yaml format, run
    httperf with each job.
    DESCRIPTION
end
