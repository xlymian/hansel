require File.dirname(__FILE__) + "/spec_helper"
require 'httperf_result_parser'
require 'httperf_result'

SAMPLE_HTTPERF_OUTPUT = <<-EOS

Maximum connect burst length: 1

Total: connections 100 requests 99 replies 98 test-duration 10.082 s

Connection rate: 9.9 conn/s (100.8 ms/conn, <=3 concurrent connections)
Connection time [ms]: min 173.3 avg 180.0 max 205.1 median 178.5 stddev 5.6
Connection time [ms]: connect 89.8
Connection length [replies/conn]: 1.000

Request rate: 9.9 req/s (100.8 ms/req)
Request size [B]: 68.0

Reply rate [replies/s]: min 9.8 avg 9.9 max 10.0 stddev 0.1 (2 samples)
Reply time [ms]: response 90.1 transfer 0.0
Reply size [B]: header 287.0 content 438.0 footer 0.0 (total 725.0)
Reply status: 1xx=0 2xx=100 3xx=0 4xx=0 5xx=1

CPU time [s]: user 1.57 system 8.50 (user 15.6% system 84.3% total 99.8%)
Net I/O: 7.7 KB/s (0.1*10^6 bps)

Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0
EOS

describe Hansel::HttperfResultParser, "#score" do
  before(:each) do
    @parser = Hansel::HttperfResultParser.new SAMPLE_HTTPERF_OUTPUT
  end

  describe "when calling parse" do
    before(:each) do
      @httperf_result = Hansel::HttperfResult.new(
        :rate       => 10,
        :server     => 'www.example.com',
        :port       => 80,
        :uri        => '/',
        :num_conns  => 100
      )
      @parser.parse @httperf_result
    end

    it "should set the passed HttperfResult object" do
      @httperf_result.class.name =~ /HttperfResult/
    end

    describe "the HttperfResult object" do
      it "initialize the rate should be 10" do
        @httperf_result.rate.should == 10
      end

      it "initialize the server to 'www.example.com'" do
        @httperf_result.server.should == 'www.example.com'
      end

      it "initialize the port to 80" do
        @httperf_result.port.should == 80
      end

      it "initialize the uri to '/'" do
        @httperf_result.uri.should == '/'
      end

      it "initialize the num_conns to 100" do
        @httperf_result.num_conns.should == 100
      end

      it "the should be replies to 98" do
        @httperf_result.replies.should == 98
      end

      it "the connection_rate should be 9.9" do
        @httperf_result.connection_rate.should == 9.9
      end

      it "the request_rate should be 9.9" do
        @httperf_result.request_rate.should == 9.9
      end

      it "should set the reply_time to 90.1" do
        @httperf_result.reply_time.should == 90.1
      end

      it "the net_io should be 7.7" do
        @httperf_result.net_io.should == 7.7
      end

      it "the errors should be 0" do
        @httperf_result.errors.should == 0
      end

      it "the status should be 1" do
        @httperf_result.status.should == 1
      end

      it "reply_rate_min should be 9.8" do
        @httperf_result.reply_rate_min.should == 9.8
      end

      it "the reply_rate_avg should be 9.9" do
        @httperf_result.reply_rate_avg.should == 9.9
      end

      it "the reply_rate_max should be 10.0" do
        @httperf_result.reply_rate_max.should == 10.0
      end

      it "the reply_rate_stddev should be 0.1" do
        @httperf_result.reply_rate_stddev.should == 0.1
      end
    end
  end
end

