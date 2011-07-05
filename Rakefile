begin
  require 'bundler'
  require 'rspec/core/rake_task'
  require 'metric_fu'
  Bundler.setup
rescue LoadError
  puts '*** You must `gem install bundler` and `bundle install` to run rake tasks'
end

$LOAD_PATH.unshift 'lib'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = [ "--color" ]
end

task :default => :spec

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

desc "Push a new version to Gemcutter"
task :publish do
  require 'hansel/version'

  sh "gem build hansel.gemspec"
  sh "gem push hansel-#{HanselCore::Version}.gem"
  sh "git tag v#{HanselCore::Version}"
  sh "git push origin v#{HanselCore::Version}"
  sh "git push origin master"
  sh "git clean -fd"
end
