module Hansel
  #
  # Output to a Octave script.
  #
  class OctaveFormatter
    def initialize(data, options = {})
      @data = data
      @options = options
      @png_output = [(options[:output_file_name] || 'stats'), 'png'].join('.')
      @rates = @data.keys.select{|key| key.instance_of? Fixnum}.map(&:to_i).sort
      @max_rate = @rates.last
      @results  = OpenStruct.new(
        :request_rate      => [],
        :connection_rate   => [],
        :reply_rate_avg    => [],
        :reply_rate_max    => [],
        :reply_time        => [],
        :reply_rate_stddev => [],
        :errors            => []
      )
    end

    def build_arrays rate, data
      %w(request_rate connection_rate reply_rate_avg reply_rate_max
      reply_time reply_rate_stddev errors).map(&:to_sym).each do |method|
        (@results.send method) << data[method]
      end
    end

    def format
      # TODO: render an erb template instead.
      @rates.each { |rate| build_arrays rate, @data[rate] }
      result = <<-EOS
        rate              = [#{@rates.join(',')}];
        request_rate      = [#{@results.request_rate.join(',')}];
        connection_rate   = [#{@results.connection_rate.join(',')}];
        reply_rate_avg    = [#{@results.reply_rate_avg.join(',')}];
        reply_rate_max    = [#{@results.reply_rate_max.join(',')}];
        reply_time        = [#{@results.reply_time.join(',')}];
        reply_rate_stddev = [#{@results.reply_rate_stddev.join(',')}];
        errors            = [#{@results.errors.join(',')}];

        plot(rate, request_rate, '-k*');
        hold on;
        plot(rate, connection_rate, '-kd');
        hold on;
        plot(rate, reply_rate_max, '-kp');
        hold on;
        plot(rate, reply_rate_max, '-k+');
        hold on;
        plot(rate, reply_rate_stddev, '-kh');
        hold on;
        plot(rate, reply_time, '-g*');
        hold on;
        plot(rate, errors, '-r*');

        grid on;

        axis([0 #{@max_rate} 0 #{@max_rate}]);
        title('Hansel report for #{@data[:server]}:#{@data[:port]}#{@data[:uri]} (#{@data[:num_conns]} connections per run)')
        xlabel('Demanded Request Rate');
        legend('Request Rate', 'Connection Rate', 'Avg. reply rate', 'Max. reply rate', 'Reply rate StdDev', 'Reply time', 'Errors');
        print('#{@png_output}', '-dpng')
      EOS
      result = result.gsub '  ', ''
      result
    end
  end
end
