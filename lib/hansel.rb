require 'fileutils'

class Hansel
  def initialize(options = {})
    @options = options
    @results = {}
  end

  def options
    @options
  end

  def verbose?
    options.verbose
  end

  def benchmark(rate)
    result = {:output => ""}
    httperf_cmd = [
      "httperf --hog",
      "--server=#{options.server}",
      "--port=#{options.port}",
      "--uri=#{options.uri}",
      "--num-conns=#{options.num_conns}",
      "--rate=#{rate}",
      options.cookie && "--add-header='Cookie: #{options.cookie}\\n'"
    ].compact.join ' '

    IO.popen("#{httperf_cmd} 2>&1") do |pipe|
      puts "\n#{httperf_cmd}"
      while line = pipe.gets
        case line
          when /^Total: .*replies (\d+)/ then result[:replies] = $1
          when /^Connection rate: (\d+\.\d)/ then result[:connection_rate] = $1
          when /^Request rate: (\d+\.\d)/ then result[:request_rate] = $1
          when /^Reply time .* response (\d+\.\d)/ then result[:reply_time] = $1
          when /^Net I\/O: (\d+\.\d)/ then result[:net_io] = $1
          when /^Errors: total (\d+)/ then result[:errors] = $1
          when /^Reply rate .*min (\d+\.\d) avg (\d+\.\d) max (\d+\.\d) stddev (\d+\.\d)/ then
            result[:reply_rate_min] = $1
            result[:reply_rate_avg] = $2
            result[:reply_rate_max] = $3
            result[:reply_rate_stddev] = $4
          when /^Reply status: 1xx=\d+ 2xx=\d+ 3xx=\d+ 4xx=\d+ 5xx=(\d+)/ then result[:status] = $1
        end
      end
    end
    result
  end

  def output
    if options.output
      FileUtils.mkdir_p options.output_dir
      output_file_name = [options.server, options.num_conns.to_s].join('.')
      output_file = File.join options.output_dir, output_file_name
      type = { :yaml => 'yml', :csv => 'csv', :octave => 'm' }[options.output_format]
      File.open([output_file, type].join('.'), "w+") do |f|
        formatter = case options.output_format
          when :yaml
            load File.here '/../lib/yaml_formatter.rb'
            YamlFormatter.new(@results)
          when :csv
            load File.here '/../lib/csv_formatter.rb'
            CsvFormatter.new(@results)
          when :octave
            load File.here '/../lib/octave_formatter.rb'
            OctaveFormatter.new(@results, {:output_file_name => output_file_name})
        end
        f.puts formatter.format
      end
    end
  end

  def run
    puts "starting run..." if verbose?
    (options.low_rate..options.high_rate).step(options.rate_step) do |rate|
      puts "benchmarking at rate: #{rate}" if verbose?
      @results[:server]     = options.server
      @results[:port]       = options.port
      @results[:uri]        = options.uri
      @results[:num_conns]  = options.num_conns
      @results[rate]        = benchmark(rate)
    end
    puts "ending run..." if verbose?
    output
    @results
  end

  trap("INT") {
    puts "Terminating tests."
    Process.exit
  }
end
