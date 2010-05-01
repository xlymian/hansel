require 'erb'

module Hansel
  #
  # Output to a Octave script.
  #
  class OctaveFormatter
    def initialize(data, options = {})
      @data     = data
      @template = options[:template]
      @rates    = @data.keys.select{|key| key.instance_of? Fixnum}.map(&:to_i).sort
      @max_rate = @rates.max
      @vars     = %w(request_rate connection_rate reply_rate_avg
                    reply_rate_max reply_time reply_rate_stddev errors)
      @vars.each { |variable| instance_variable_set "@#{variable}", [] }
      @png_output = [(options[:output_file_name] || 'stats'), 'png'].join('.')
    end

    # Gather values for rate
    #
    def collate_for_rate rate
      @vars.each { |variable| (instance_variable_get "@#{variable}") << @data[rate][variable.to_sym] }
    end

    # For each value of rate, collate the values in each variable in @vars
    # and format using the erb template
    def format
      @rates.each { |rate| collate_for_rate rate }
      (@vars + ['rates']).each do |variable|
        var = "@#{variable}"
        instance_variable_set var, instance_variable_get(var).join(', ')
      end
      ERB.new(File.read(@template)).result(binding)
    end
  end
end
