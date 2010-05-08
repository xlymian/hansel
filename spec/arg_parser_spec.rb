require File.dirname(__FILE__) + "/spec_helper"
require 'arg_parser'

describe Hansel::ArgParser, "#parse" do
  before :each do
    @argv = [
      '--server=frunobulax.local',
      '--port=4000',
      '--uri=/',
      '--num_conns=1',
      '--low_rate=1',
      '--high_rate=5',
      '--rate_step=1',
      '--format=octave',
      '--output=true'
      ]
    @options = Hansel::ArgParser.new(@argv).parse
  end

  describe "should set the" do
    it "server to 'frunobulax.local'" do
      @options.server.should == 'frunobulax.local'
    end

    it "port to 4000" do
      @options.port.should == 4000
    end

    it "uri to '/" do
      @options.uri.should == '/'
    end

    it "num_conns to 1" do
      @options.num_conns.should == 1
    end

    it "low_rate to 1" do
      @options.low_rate.should == 1
    end

    it  "high_rate to 5" do
      @options.high_rate.should == 5
    end

    it "rate_step to 1" do
      @options.rate_step.should == 1
    end

    it "output_format to 'octave'" do
      @options.output_format.should == :octave
    end

    it "output to 'true'" do
      @options.output.should == true
    end
  end
end
