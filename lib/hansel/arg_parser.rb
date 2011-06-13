require 'ostruct'

module HanselCore
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
        :output_format  => :yaml,
        :output_dir     => File.join(ENV['HOME'], 'hansel_output'),
        :template_path  => 'templates',
        :template       => nil,
        :exit           => false,
        :master         => nil
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

    def output_options options
      options.on("-f", "--format=format",
          "Specify the ouptut format for the results.") do |format|
        @options.format = format
      end
      options.on("-d", "--dir=output directory",
          "Specify the ouptut directory for the results.") do |format|
        @options.output_dir = format
      end
      options.on("-t", "--template=template",
          "Specify the ouptut erb template.") do |template|
        @options.template = template
      end
    end

    def other_options options
      options.on("-v", "--[no-]verbose", "Run verbosely") do |verbose|
        @options.verbose = verbose
      end

      options.on_tail("-h", "--help", "Show this message") do
        puts options
        @options.exit = true
      end
    end

    def distributed_mode_options options
      options.on("-m", "--master=hostname[:port]",
          "Specify the master command and control machine.") do |master|
        @options.master = master
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
      %w( output_options other_options version distributed_mode_options ).map(&:to_sym).each do |method|
          self.send method, options
      end
    end
  end
end
