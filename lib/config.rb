module Hansel
  #
  # Loads and parses the configuration file
  #
  class Config
    def initialize(argv)
      @argv = argv
      @args = []
    end

    #
    # The main configuration directory: defaults to ~/.hansel
    # Creates the configuration directory if it doesn't exist.
    #
    def config_path
      @config_path ||= File.join [ENV['HOME'], '.hansel']
      FileUtils.mkdir_p @config_path unless File.exists? @config_path
      @config_path
    end

    #
    # The options file located in the configuration directory
    #
    def options_path
      @options_path ||= File.join config_path, 'options'
    end

    def read_lines file
      file.read.split("\n").each do |line|
        next if line =~ /#+/
        @args += line.split(' ')
      end
    end

    def read_file path
      File.open path do |file|
        read_lines file
      end
    end

    #
    # Reads the options file and returns an Array of String objects.
    # Line starting with '#' are skipped.
    #
    def read_config_file
      path = options_path
      if File.exists? path
        read_file path
      end
      @args
    end

    #
    # Returns an OpenStruct object with the options
    #
    def options
      @options ||= ArgParser.new(read_config_file + @argv).parse
    end
  end
end
