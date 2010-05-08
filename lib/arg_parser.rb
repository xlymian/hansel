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
        :verbose        => false,
        :server         => 'localhost',
        :port           => '80',
        :uri            => '/',
        :num_conns      => 1,
        :rate           => 1,
        :cookie         => nil,
        :low_rate       => 1,
        :high_rate      => 2,
        :rate_step      => 1,
        :output_format  => :yaml,
        :output         => nil,
        :output_dir     => File.join(ENV['HOME'], 'hansel_output'),
        :template_path  => 'templates',
        :template       => nil,
        :exit           => false
      )
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

  private

    def server_options options
      options.on("-s", "--server=S",
          "Specifies the IP hostname of the server.") do |server|
        @options.server = server
      end

      options.on("-p", "--port=N",
          "Specifies the port number on which the server is listening.") do |port|
        @options.port = port.to_i
      end

      options.on("-u", "--uri=S",
          "Specifies that URI S should be accessed on the server.") do |uri|
        @options.uri = uri
      end
    end

    def httperf_options options
      options.on("-n", "--num_conns=N",
          "Specifies the total number of connections to create.") do |num_conns|
        @options.num_conns = num_conns.to_i
      end

      options.on("-l", "--low_rate=S",
          "Specifies the starting fixed rate at which connections are created.") do |low_rate|
        @options.low_rate = low_rate.to_i
      end

      options.on("-l", "--high_rate=S",
          "Specifies the ending fixed rate at which connections are created.") do |high_rate|
        @options.high_rate = high_rate.to_i
      end

      options.on("-l", "--rate_step=S",
          "Specifies the fixed rate step at which connections are created.") do |rate_step|
        @options.rate_step = rate_step.to_i
      end
    end

    def output_options options
      options.on("-f", "--format=FORMAT [yaml|csv|octave]",
          "Specify an output format.") do |format|
        @options.output_format = format.to_sym
      end

      options.on("-o", "--output=FILE", "Specify an output file.") do |output|
        @options.output = !!output
      end

      options.on("-d", "--output_dir=PATH",
          "Specify an output directory.") do |output_dir|
        @options.output_dir = output_dir
      end
    end

    def template_options options
      options.on("-m", "--template_path=PATH", "Specify template path.") do |template_path|
        @options.template_path = template_path
      end

      options.on("-t", "--template=TEMPLATE_NAME",
          "Specify a template for output.") do |template|
        @options.template = template
      end
    end

    def other_options options
      options.on("-c", "--cookie=C", "Specify a cookie.") do |cookie|
        @options.cookie = cookie
      end

      options.on("-v", "--[no-]verbose", "Run verbosely") do |verbose|
        @options.verbose = verbose
      end

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
      %w(server_options httperf_options output_options
          other_options version).map(&:to_sym).each do |method|
          self.send method, options
      end
    end

  end
end
