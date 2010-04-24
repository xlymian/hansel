require 'fileutils'
module Hansel
  #
  # Class wrapper over httperf.
  #
  class Hansel
    def initialize(options = {})
      @options = options
      @results = {}
      @current_rate = nil
    end

    def options
      @options
    end

    def parse_replies line
      @result[:replies] = $1 if line =~ /^Total: .*replies (\d+)/
    end

    def parse_connection_rate line
      @result[:connection_rate] = $1 if line =~ /^Connection rate: (\d+\.\d)/
    end

    def parse_request_rate line
      @result[:request_rate] = $1 if line =~ /^Request rate: (\d+\.\d)/
    end

    def parse_reply_time line
      @result[:reply_time] = $1 if line =~ /^Reply time .* response (\d+\.\d)/
    end

    def parse_net_io line
      @result[:net_io] = $1 if line =~ /^Net I\/O: (\d+\.\d)/
    end

    def parse_errors line
      @result[:errors] = $1 if line =~ /^Errors: total (\d+)/
    end

    def parse_status line
      @result[:status] = $1 if line =~ /^Reply status: 1xx=\d+ 2xx=\d+ 3xx=\d+ 4xx=\d+ 5xx=(\d+)/
    end

    def parse_reply_rate line
      if line =~ /^Reply rate .*min (\d+\.\d) avg (\d+\.\d) max (\d+\.\d) stddev (\d+\.\d)/
        @result[:reply_rate_min]     = $1
        @result[:reply_rate_avg]     = $2
        @result[:reply_rate_max]     = $3
        @result[:reply_rate_stddev]  = $4
      end
    end

    def parse_line line
      %w(parse_replies parse_connection_rate parse_request_rate
      parse_reply_time parse_net_io parse_errors parse_status
      parse_reply_rate).map(&:to_sym).each do |method|
        self.send method, line
      end
    end

    def parse pipe
      @result = {:output => ""}
      while line = pipe.gets
        parse_line line
      end
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
        parse pipe
      end
      @results[@current_rate] = @result
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
      OctaveFormatter.new(@results, {:output_file_name => @output_file_name})
    end

    def make_formatter format
      case format
        when :yaml
          yaml_formatter
        when :csv
          csv_formatter
        when :octave
          octave_formatter
      end
    end

    def formatted_output
      @output_file_name = [@options.server, @options.num_conns.to_s].join('.')
      output_file = File.join @options.output_dir, @output_file_name
      output_format = @options.output_format
      type = { :yaml => 'yml', :csv => 'csv', :octave => 'm' }[output_format]
      File.open([output_file, type].join('.'), "w+") do |file|
        file.puts make_formatter(output_format).format
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

    def one_run
      @results[:server]       = @options.server
      @results[:port]         = @options.port
      @results[:uri]          = @options.uri
      @results[:num_conns]    = @options.num_conns
      httperf
    end

    def run_all
      (@options.low_rate.to_i..@options.high_rate.to_i).step(@options.rate_step.to_i) do |rate|
        status "running httperf at rate: #{rate}"
        @current_rate = rate
        one_run
      end
    end

    # 
    # Run httperf from low_rate to high_rate, stepping by rate_step
    # 
    def run
      status "starting run..."
      run_all
      status "ending run..."
      output
      @results
    end

    trap("INT") {
      puts "Terminating."
      Process.exit
    }
  end
end
