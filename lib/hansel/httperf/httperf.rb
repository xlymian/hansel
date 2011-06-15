module HanselCore
  module Httperf
    def build_httperf_cmd
      cookie = @current_job.cookie
      httperf_cmd = [
        "httperf --hog",
        "--server=#{@current_job.server}",
        "--port=#{@current_job.port}",
        "--uri=#{@current_job.uri}",
        "--num-conns=#{@current_job.num_conns}",
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
      # Do a pre-flight run to setup any resources
      status "\n#{httperf_cmd} (warm up run)"
      IO.popen("#{httperf_cmd} 2>&1")

      IO.popen("#{httperf_cmd} 2>&1") do |pipe|
        status "\n#{httperf_cmd}"
        @results << (httperf_result = HttperfResult.new({
            :rate       => @current_rate,
            :server     => @current_job.server,
            :port       => @current_job.port,
            :uri        => @current_job.uri,
            :num_conns  => @current_job.num_conns
          }))
        HttperfResultParser.new(pipe).parse(httperf_result)
      end
    end

  end
end