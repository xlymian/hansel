require File.dirname(__FILE__) + "/spec_helper"

require 'typhoeus'
require 'json'
require 'yaml'
require 'ostruct'

describe HanselCore, "in general" do
  before :each do
    @hansel = HanselCore::Hansel.new
    @hansel.stub(:config_path).and_return 'spec'
  end

  it "should have an empty job queue" do
    @hansel.should respond_to :push_job
    @hansel.should respond_to :jobs
    @hansel.jobs.length.should == 0
  end

  describe "adding to the job queue" do
    before :each do
      jobs = YAML.load_file(File.join ['spec', 'jobs.yml']).map{ |job| OpenStruct.new job }
      jobs.each{ |job| @hansel.push_job job }
    end

    it "should have some jobs" do
      @hansel.jobs.length.should > 0
    end
  end

  describe "when calling run" do
    before :each do
      @hansel.stub( :httperf ).and_return @hansel
      @hansel.load_job_queue
    end

    describe "initially" do
      it "should have some jobs" do
        @hansel.jobs.length.should > 0
      end
    end

    describe "on completion" do
      before :each do
        @hansel.run
      end

      it "should have an empty job queue" do
        @hansel.jobs.length.should == 0
      end

      it "should have results to output" do
        @hansel.should respond_to :results
      end
    end
  end

  describe "after a run" do
    before :each do
      result = HanselCore::HttperfResult.new  :server     => "localhost",
                                              :port       => 80,
                                              :rate       => 1,
                                              :uri        => "/",
                                              :num_conns  => 1

      result.reply_time         = 0.0
      result.status             = 0
      result.reply_rate_avg     = 0.0
      result.request_rate       = 0.0
      result.reply_rate_min     = 0.0
      result.connection_rate    = 6754.1
      result.errors             = 1
      result.reply_rate_stddev  = 0.0
      result.net_io             = 0.0
      result.replies            = 0
      result.reply_rate_max     = 0.0

      @hansel.stub( :results ).and_return [ result ]
      @hansel.stub( :options ).and_return HanselCore::ArgParser.
                                new( [ '--format=yaml', '--dir=/tmp/hansel_output' ] ).parse
    end

    describe "calling output" do
      before :each do
        @default_name = File.join [ @hansel.options.output_dir, 'localhost:80.yml' ]
        FileUtils.rm @default_name if File.exists? @default_name
        @hansel.output
      end

      it "should have stubbed results" do
        @hansel.results.size.should > 0
      end

      describe "should put the output into a file in the specified format" do
        it "should be in a file with the default file name" do
          @default_name.should == @hansel.output_filename
          File.exists?( @default_name ).should be_true
        end
      end
    end
  end
end

describe HanselCore, "in distributed mode" do
  before :each do
    @options = HanselCore::ArgParser.new( [ '--master=localhost:4000' ] ).parse
  end

  describe "should register with the master" do
    before :each do
      response = Typhoeus::Response.new(
          :code     => 200,
          :headers  => "",
          :body     => { :token => '0123456789' }.to_json,
          :time     => 0.3)
      Typhoeus::Request.stub(:get, @options.master).and_return response
    end

    describe "when initialized" do
      before :each do
        @hansel = HanselCore::Hansel.new @options
        @hansel.stub(:config_path).and_return 'spec'
      end

      it "should be able to register with the master server" do
        @hansel.should respond_to :register
      end

      it "should return the access token when registring with the master server" do
        @hansel.register.should == '0123456789'
      end
    end
  end
end
