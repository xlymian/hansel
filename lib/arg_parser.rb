module Hansel
  #
  # Parse the command configuration file options and command line arguments.
  # Command line arguments override those from the configuration file
  # See http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
  #
  class ArgParser
    #
    # Setup default values for the parsed options
    #
    def initialize args
      @args     = args
      @options  = OpenStruct.new(
        :verbose       => false,
        :server        => 'localhost',
        :port          => '80',
        :uri           => '/',
        :num_conns     => 1,
        :rate          => 1,
        :cookie        => nil,
        :low_rate      => 1,
        :high_rate     => 2,
        :rate_step     => 1,
        :output_format => :yaml,
        :output        => nil,
        :output_dir    => File.join(ENV['HOME'], 'hansel_output'),
        :exit          => false
      )
    end

    def server options
      options.on("-s", "--server=S",
              "Specifies the IP hostname of the server.") do |opt|
        @options.server = opt
      end
    end

    def port options
      options.on("-p", "--port=N",
        "This option specifies the port number N on which the web server is listening for HTTP requests.") do |opt|
        @options.port = opt
      end
    end

    def uri options
      options.on("-u", "--uri=S",
              "Specifies that URI S should be accessed on the server.") do |opt|
        @options.uri = opt
      end
    end

    def connections options
      options.on("-n", "--num_conns=N",
              "Specifies the total number of connections to create.") do |opt|
        @options.num_conns = opt
      end
    end

    def low_rate options
      options.on("-l", "--low_rate=S",
              "Specifies the starting fixed rate at which connections are created.") do |opt|
        @options.low_rate = opt
      end
    end

    def high_rate options
      options.on("-l", "--high_rate=S",
              "Specifies the ending fixed rate at which connections are created.") do |opt|
        @options.high_rate = opt
      end
    end

    def rate_step options
      options.on("-l", "--rate_step=S",
              "Specifies the fixed rate step at which connections are created.") do |opt|
        @options.rate_step = opt
      end
    end

    def cookie options
      options.on("-c", "--cookie=C", "Specify a cookie.") do |opt|
        @options.cookie = opt
      end
    end

    def format options
      options.on("-f", "--format=FILE [yaml|csv]", "Specify an output format.") do |opt|
        @options.output_format = opt.to_sym
      end
    end

    def output options
      options.on("-o", "--output=FILE", "Specify an output file.") do |opt|
        @options.output = opt
      end
    end

    def output_dir options
      options.on("-d", "--output_dir=PATH", "Specify an output directory.") do |opt|
        @options.output_dir = opt
      end
    end

    def verbose options
      options.on("-v", "--[no-]verbose", "Run verbosely") do |opt|
        @options.verbose = opt
      end
    end

    def help options
      options.on_tail("-h", "--help", "Show this message") do
        puts options
        @options.exit = true
      end
    end

    def version options
      options.on_tail("--version", "Show version") do
        puts "Hansel version #{IO.foreach('VERSION').first.strip}"
        @options.exit = true
      end
    end

    def parse_options options
      options.banner = "Usage: hansel [options]"
      options.separator "Options:"
      %w(server port uri connections low_rate high_rate rate_step cookie
        format output output_dir verbose help version).map(&:to_sym).each do |method|
          self.send method, options
      end
    end

    #
    # Uses OptionParser to return an OpenStruct object describing the options.
    #
    def parse
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      OptionParser.new { |options| parse_options options}.parse!(@args)
      @options
    end

  end
end
