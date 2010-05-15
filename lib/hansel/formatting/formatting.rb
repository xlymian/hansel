module HanselCore
  module Formatting
    def yaml_formatter
      load 'lib/hansel/formatting/yaml_formatter.rb'
      File.open(output_filename, "w+") do |file|
        file.puts YamlFormatter.format results
      end
    end

    def csv_formatter
      load 'lib/hansel/formatting/csv_formatter.rb'
      File.open(output_filename, "w+") do |file|
        file.puts CsvFormatter.format results
      end
    end

    def octave_formatter
      load 'lib/hansel/formatting/octave_formatter.rb'
      num_conns = results.first.num_conns rescue nil
      file_name = output_filename{ "-#{num_conns.to_s}" }
      File.open(file_name, "w+") do |file|
        file.puts OctaveFormatter.new(results, 
          {
            :output_file_name => file_name,
            :template         => options.template ||
                                  File.join( [ options.template_path, 'octave.m.erb' ] ),
          }
        ).format
      end
    end

    def formatted_output
      formatter = "#{options.format}_formatter".to_sym
      unless self.respond_to? formatter
        status "Using default octave_formatter"
        octave_formatter
      else
        status "Using #{formatter}"
        self.send formatter
      end
    end

    def output_filename
      part    = block_given? ? yield : ''
      type    = { :yaml => 'yml', :csv => 'csv', :octave => 'm' }[options.format.to_sym]
      server  = results.first.server
      port    = results.first.port
      [File.join([options.output_dir, ("#{server}:#{port}" + part)]), type].join('.')
    end
  end
end
