require File.dirname(__FILE__) + "/spec_helper"

describe HanselCore::ArgParser, "#parse" do
  before :each do
  end

  describe "when the option" do
    describe "master is set to 'localhost:4000'" do
      it "should set master" do
        @argv = [ '--master=localhost:4000' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.master.should == 'localhost:4000'
      end

      it "should set master" do
        @argv = [ '-mlocalhost:4000' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.master.should == 'localhost:4000'
      end
    end

    describe "dir is set to '/tmp/hansel_output'" do
      it "should set output_dir" do
        @argv = [ '--dir=/tmp/hansel_output' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.output_dir.should == '/tmp/hansel_output'
      end

      it "should set output_dir" do
        @argv = [ '-d/tmp/hansel_output' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.output_dir.should == '/tmp/hansel_output'
      end

      it "should set template" do
        @argv = [ '--template=/home/templates' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.template.should == '/home/templates'
      end

      it "should set template" do
        @argv = [ '-t/home/templates' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.template.should == '/home/templates'
      end
    end

    %w(yaml csv octave).each do |format|
      describe "output --format is set to #{format}" do
        it "should set format #{format}" do
          @argv = [ "--format=#{format}" ]
          @options = HanselCore::ArgParser.new(@argv).parse
          @options.format.should == format
        end

        it "should set format to #{format}" do
          @argv = [ "-f#{format}" ]
          @options = HanselCore::ArgParser.new(@argv).parse
          @options.format.should == format
        end
      end
    end

    describe "verbose is set" do
      it "should set verbose to true" do
        @argv = [ '--verbose' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.verbose.should == true
      end
      it "should set verbose to true" do
        @argv = [ '-v' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.verbose.should == true
      end
    end

    describe "no-verbose is set" do
      it "should set verbose to false" do
        @argv = [ '--verbose', '--no-verbose' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.verbose.should == false
      end
    end

    describe "verbose is not set" do
      it "verbose defaults to false" do
        @argv = [ ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.verbose.should == false
      end
    end

    describe "help is set" do
      it "should set exit to true" do
        @argv = [ '--help' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.exit.should == true
      end
      it "should set exit to true" do
        @argv = [ '-h' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.exit.should == true
      end
    end

    describe "version is set" do
      it "should set exit to true" do
        @argv = [ '--version' ]
        @options = HanselCore::ArgParser.new(@argv).parse
        @options.exit.should == true
      end
    end
  end
end
