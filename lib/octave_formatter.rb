class OctaveFormatter
  def initialize(data)
    @data = data
  end

  def format
    rate              = @data.keys.reject{|x| x.instance_of? Symbol}.map(&:to_i).sort
    request_rate      = rate.collect{|x| @data[x][:request_rate]}
    connection_rate   = rate.collect{|x| @data[x][:connection_rate]}
    reply_rate_avg    = rate.collect{|x| @data[x][:reply_rate_avg]}
    reply_rate_max    = rate.collect{|x| @data[x][:reply_rate_max]}
    reply_rate_stddev = rate.collect{|x| @data[x][:reply_rate_stddev]}
    errors            = rate.collect{|x| @data[x][:errors]}

    result = <<-EOS
      rate              = [#{rate.join(',')}];
      request_rate      = [#{request_rate.join(',')}];
      connection_rate   = [#{connection_rate.join(',')}];
      reply_rate_avg    = [#{reply_rate_avg.join(',')}];
      reply_rate_max    = [#{reply_rate_max.join(',')}];
      reply_rate_stddev = [#{reply_rate_stddev.join(',')}];
      errors            = [#{errors.join(',')}];

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
      plot(rate, errors, '-r<');

      grid on;

      axis([0 #{rate.last} 0 #{rate.last}]);
      title('Hansel report for #{@data[:server]}:#{@data[:port]}#{@data[:uri]} (#{@data[:num_conns]} connections per run)')
      xlabel('Demanded Request Rate');
      legend('Request Rate', 'Connection Rate', 'Avg. reply rate', 'Max. reply rate', 'Reply rate StdDev', 'Errors');
      print('stats.png', '-dpng')
    EOS
    result = result.gsub '  ', ''
    result
  end
end
