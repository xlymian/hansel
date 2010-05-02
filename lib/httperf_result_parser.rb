module Hansel
  #
  # Parse httperf output.
  #
  class HttperfResultParser
    attr_accessor :rate, :replies, :connection_rate, :request_rate, :reply_time,
                  :net_io, :errors, :status, :reply_rate_min, :reply_rate_avg,
                  :reply_rate_max, :reply_rate_stddev

    def initialize input
      @input = input
    end

    def parse_replies line
      @httperf_result.replies = $1.to_i if line =~ /^Total: .*replies (\d+)/
    end

    def parse_connection_rate line
      @httperf_result.connection_rate = $1.to_f if line =~ /^Connection rate: (\d+\.\d)/
    end

    def parse_request_rate line
      @httperf_result.request_rate = $1.to_f if line =~ /^Request rate: (\d+\.\d)/
    end

    def parse_reply_time line
      @httperf_result.reply_time = $1.to_f if line =~ /^Reply time .* response (\d+\.\d)/
    end

    def parse_net_io line
      @httperf_result.net_io = $1.to_f if line =~ /^Net I\/O: (\d+\.\d)/
    end

    def parse_errors line
      @httperf_result.errors = $1.to_i if line =~ /^Errors: total (\d+)/
    end

    def parse_status line
      @httperf_result.status = $1.to_i if line =~ /^Reply status: 1xx=\d+ 2xx=\d+ 3xx=\d+ 4xx=\d+ 5xx=(\d+)/
    end

    def parse_reply_rate line
      if line =~ /^Reply rate .*min (\d+\.\d) avg (\d+\.\d) max (\d+\.\d) stddev (\d+\.\d)/
        @httperf_result.reply_rate_min     = $1.to_f
        @httperf_result.reply_rate_avg     = $2.to_f
        @httperf_result.reply_rate_max     = $3.to_f
        @httperf_result.reply_rate_stddev  = $4.to_f
      end
    end

    def parse_line line
      %w(parse_replies parse_connection_rate parse_request_rate
      parse_reply_time parse_net_io parse_errors parse_status
      parse_reply_rate).map(&:to_sym).each do |method|
        self.send method, line
      end
    end

    def parse httperf_result
      @httperf_result = httperf_result 
      @input.each_line do |line|
        parse_line line
      end
      self
    end
  end
end
