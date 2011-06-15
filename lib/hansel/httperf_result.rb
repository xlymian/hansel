module HanselCore
  #
  # Wrapper for parsing of the httperf run result.
  #
  class HttperfResult
    attr_accessor :rate, :server, :port, :uri, :num_conns, :replies,
                  :connection_rate, :request_rate, :reply_time, :net_io,
                  :errors, :status, :reply_rate_min, :reply_rate_avg,
                  :reply_rate_max, :reply_rate_stddev

    def initialize opt
      @rate       = opt[:rate]
      @server     = opt[:server]
      @port       = opt[:port]
      @uri        = opt[:uri]
      @num_conns  = opt[:num_conns]
    end

    def post_deserialize
      puts "** I'm awake!"
    end

  end
end