require 'fileutils'
require 'lib/httperf_result_parser'
require 'lib/httperf_result'

module Hansel
  #
  # Class wrapper over httperf.
  #
  class Hansel
    def initialize(options = {})
      @options = options
      @results = []
      @current_rate = nil
    end

    def build_httperf_cmd
      cookie = @options.cookie
      httperf_cmd = [
        "httperf --hog",
        "--server=#{@options.server}",
        "--port=#{@options.port}",
        "--uri=#{@options.uri}",
        "--num-conns=#{@options.num_conns}",
        "--rate=#{@current_rate}",
        cookie && "--add-header='Cookie: #{cookie}\\n'"
      ].compact.join ' '
    end

    #
    # Runs httperf with a given request rate. Parses the output and returns
    # a hash with the results.
    #
    def httperf
      httperf_cmd = build_httperf_cmd
      IO.popen("#{httperf_cmd} 2>&1") do |pipe|
        puts "\n#{httperf_cmd}"
        @results << (httperf_result = HttperfResult.new({
            :rate       => @current_rate,
            :server     => @options.server,
            :port       => @options.port,
            :uri        => @options.uri,
            :num_conns  => @options.num_conns
          }))
        HttperfResultParser.new(pipe).parse(httperf_result)
      end
    end

    def yaml_formatter
      load File.here '/../lib/yaml_formatter.rb'
      YamlFormatter.new(@results)
    end

    def csv_formatter
      load File.here '/../lib/csv_formatter.rb'
      CsvFormatter.new(@results)
    end

    def octave_formatter
      load File.here '/../lib/octave_formatter.rb'
      puts @output_file_name
      OctaveFormatter.new(@results, {
          :output_file_name => @output_file_name,
          :template         => File.join([@options.template_path,
                                      @options.template || 'octave.m.erb']),
        }
      )
    end

    def format format
      formatter = "#{format}_formatter".to_sym
      unless self.respond_to? formatter
        puts "Using default octave_formatter"
        octave_formatter
      else
        puts "Using #{formatter}"
        self.send formatter
      end
    end

    def formatted_output
      @output_file_name = [@options.server, @options.num_conns.to_s].join('.')
      output_file = File.join @options.output_dir, @output_file_name
      output_format = @options.output_format
      type = { :yaml => 'yml', :csv => 'csv', :octave => 'm' }[output_format]
      File.open([output_file, type].join('.'), "w+") do |file|
        file.puts format(output_format).format
      end
    end

    #
    # Output the results based on the requested output format
    #
    def output
      if @options.output
        FileUtils.mkdir_p @options.output_dir
        formatted_output
      end
    end

    def status text
      puts text if @options.verbose
    end

    def run_all
      (@options.low_rate.to_i..@options.high_rate.to_i).step(@options.rate_step.to_i) do |rate|
        status "running httperf at rate: #{rate}"
        @current_rate = rate
        httperf
      end
    end

    #
    # Run httperf from low_rate to high_rate, stepping by rate_step
    #
    def run
      status "starting run..."
      run_all
      output
      status "ending run..."
    end

    trap("INT") {
      puts "Terminating."
      Process.exit
    }
  end
end
