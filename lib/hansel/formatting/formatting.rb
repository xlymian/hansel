module HanselCore
  module Formatting
    def yaml_formatter
      File.open(output_filename, "w+") do |file|
        file.puts YamlFormatter.format results
      end
    end

    def csv_formatter
      File.open(output_filename, "w+") do |file|
        file.puts CsvFormatter.format results
      end
    end

    def octave_formatter
      res = results
      opts, num_conns = options, (res.first.num_conns rescue nil)
      file_name = output_filename{ "-#{num_conns.to_s}" }
      template = opts.template || File.join( [ File.dirname(__FILE__), '../../..', opts.template_path, 'octave.m.erb' ] )
      File.open(file_name, "w+") do |file|
        file.puts OctaveFormatter.new(res,
            { :output_file_name => file_name,
              :template         => template,
              :png_file_name    => "#{@server}:#{@port}-#{num_conns.to_s}.png"
            }).format
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
      opts, part = options, (block_given? ? yield : '')
      type    = { :yaml => 'yml', :csv => 'csv', :octave => 'm' }[opts.format.to_sym]
      @server, @port = (res = results.first) && res.server, res.port
      [File.join([opts.output_dir, ("#{@server}:#{@port}" + part)]), type].join('.')
    end
  end
end
