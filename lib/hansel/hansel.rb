module HanselCore
  #
  # Class wrapper over httperf.
  #
  class Hansel
    include Formatting
    include Httperf
    include JobQueue

    attr_reader :results, :options

    def initialize options = OpenStruct.new {}
      @options = options
      @results = []
      @current_rate = nil
      @jobs = []
    end

    def config_path
      @config_path ||= File.join [ENV['HOME'], '.hansel']
      FileUtils.mkdir_p @config_path unless File.exists? @config_path
      @config_path
    end

    def output_dir
      @output_dir ||= File.join [ENV['HOME'], 'hansel_output']
      @output_dir
    end

    def register
      response = Typhoeus::Request.get options.master
      @token = JSON.parse(response.body)['token']
    end

    #
    # Output the results based on the requested output format
    #
    def output
      if options.format
        FileUtils.mkdir_p options.output_dir
        formatted_output
      end
    end

    def status text
      puts text if options.verbose
    end

    #
    # Run httperf from low_rate to high_rate, stepping by rate_step
    #
    def run
      status "starting run..."
      while @jobs.length > 0 do
        @current_job = @jobs.pop
        (@current_job.low_rate.to_i..@current_job.high_rate.to_i).step(@current_job.rate_step.to_i) do |rate|
          status "running httperf at rate: #{rate}"
          @current_rate = rate
          httperf
        end
        output
        @results.clear
      end
      status "ending run..."
    end

    def run_server
      HanselSlaveServer.hansel = self
      HanselSlaveServer.run! :host => 'localhost', :port => 4000
    end

    trap("INT") {
      puts "Terminating."
      Process.exit
    }
  end
end
