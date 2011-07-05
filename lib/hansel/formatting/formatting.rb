module HanselCore
  module Formatting
    def yaml_formatter
      File.open(output_filename, "w+") do |file|
        file.puts YamlFormatter.format results
        # file.puts YamlFormatter.format results.merge({
        #   :description => @current_job.description
        # })
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
      file_name = output_filename{ "#{num_conns.to_s}" }

      template_name = (opts.template && opts.template + '.m.erb') || 'octave.m.erb'
      template = File.join( [ File.dirname(__FILE__),
                              '../../..',
                              opts.template_path,
                              template_name ] )

      description = @current_job && @current_job.description
      File.open(file_name, "w+") do |file|
        file.puts OctaveFormatter.new(res,
            { :output_file_name => file_name,
              :template         => template,
              :description      => @description,
              :png_file_name    => [ @server, @port, description, num_conns.to_s ].compact.join('-')
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
      part = [ @current_job && @current_job.description, ( yield if block_given? ) ].compact
      type    = { :yaml => 'yml', :csv => 'csv', :octave => 'm' }[options.format.to_sym]
      @server, @port = (res = results.first) && res.server, res.port
      fname = [@server, @port, (part unless part.empty?)].compact.join('-')
      [ File.join( [options.output_dir, fname] ), type ].join('.')
    end
  end
end
