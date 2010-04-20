# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hansel}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Mylchreest"]
  s.date = %q{2010-04-20}
  s.default_executable = %q{hansel}
  s.description = %q{Ruby driver for httperf - automated load and performance testing}
  s.email = %q{paul.mylchreest@mac.com}
  s.executables = ["hansel"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/hansel",
     "hansel.gemspec",
     "hansel.rb",
     "lib/arg_parser.rb",
     "lib/config.rb",
     "lib/csv_formatter.rb",
     "lib/hansel.rb",
     "lib/mutter.rb",
     "lib/octave_formatter.rb",
     "lib/yaml_formatter.rb"
  ]
  s.homepage = %q{http://github.com/xlymian/hansel}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby driver for httperf - automated load and performance testing}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mutter>, [">= 0.5.2"])
    else
      s.add_dependency(%q<mutter>, [">= 0.5.2"])
    end
  else
    s.add_dependency(%q<mutter>, [">= 0.5.2"])
  end
end

