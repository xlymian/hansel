require 'rubygems'
require 'rake'

begin
  require "spec/rake/spectask"
rescue LoadError
  puts "rspec (or a dependency) not available. Install it with: gem install rspec"
end

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-fs -c)
  t.spec_files = FileList["spec/**_spec.rb"]
end

begin
  require 'metric_fu'
rescue LoadError
  puts "metric_fu (or a dependency) not available. Install it with: gem install metric_fu"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "hansel"
    gem.executables = "hansel"
    gem.summary     = %Q{Ruby driver for httperf - automated load and performance testing}
    gem.description = %Q{Ruby driver for httperf - automated load and performance testing}
    gem.email       = "paul.mylchreest@mac.com"
    gem.homepage    = "http://github.com/xlymian/hansel"
    gem.authors     = ["Paul Mylchreest"]

    gem.add_dependency 'typhoeus'

    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'gherkin'
    gem.add_development_dependency 'cucumber'

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

MetricFu::Configuration.run do |config|
  #define which metrics you want to use
  config.metrics  = [:churn, :saikuro, :flog, :flay, :reek, :roodi]
  config.graphs   = [:flog, :flay, :reek, :roodi]
  config.flay     = { :dirs_to_flay => ['app', 'lib'],
                      :minimum_score => 100  } 
  config.flog     = { :dirs_to_flog => ['app', 'lib']  }
  config.reek     = { :dirs_to_reek => ['app', 'lib']  }
  config.roodi    = { :dirs_to_roodi => ['app', 'lib'] }

  config.saikuro  = { :output_directory => 'scratch_directory/saikuro', 
                      :input_directory => ['app', 'lib'],
                      :cyclo => "",
                      :filter_cyclo => "0",
                      :warn_cyclo => "5",
                      :error_cyclo => "7",
                      :formater => "text"} #this needs to be set to "text"
  config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}

  config.rcov     = { :environment => 'test',
                      :test_files => ['spec/**/*_spec.rb'],
                      :rcov_opts => ["--sort coverage", 
                                     "--no-html", 
                                     "--text-coverage",
                                     "--no-color",
                                     "--profile",
                                     "--rails",
                                     "--exclude /gems/,/Library/,spec"]}

  config.graph_engine = :bluff
end
