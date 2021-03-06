require 'erb'

module HanselCore
  #
  # Output to a Octave script.
  #
  class OctaveFormatter
    def initialize(data, options = {})
      @data         = data
      @template     = options[:template]
      @rates        = @data.map &:rate
      @max_rate     = @rates.max
      @png_output   = options[:png_file_name].gsub( '.', '_') # make latex happy
      @description  = options[:description]
    end

    # For each value of rate, collate the values in each variable in @vars
    # and format using the erb template
    def format
      ERB.new(File.read(@template)).result binding
    end
  end
end
