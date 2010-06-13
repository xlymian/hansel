# hansel

Hansel is a pure ruby driver for httperf for automated load and performance testing. It will load 
a job queue file, in a yaml format, run httperf with each job

# Installing Httperf and Hansel

## Httperf

  For Linux (Ubuntu):

    apt-get update && apt-get -y install rubygems httperf ruby1.8-dev libcurl4-gnutls-dev

  On MacOS X using homebrew:

    brew install httperf

  finally:
  
    gem install hansel

## Optional -- Installing Octave using macports (warning: long!)

    sudo port install octave

# Example usage

Create a job queue file in ~/.hansel/jobs.yml:

---
  - :server: www.example.com
    :uri: /
    :num_conns: 50
    :low_rate: 10
    :high_rate: 50
    :rate_step: 10

  - :server: www.apple.com
    :uri: /
    :num_conns: 50
    :low_rate: 10
    :high_rate: 50
    :rate_step: 10

and run Hansel

    export PATH=$PATH:/var/lib/gems/1.8/bin
    hansel --verbose --format=octave

By default, the output is written into the ~/hansel_output directory. When the octave format is
specified, it uses the default template octave.m.erb in the project templates. Here is a sample
output from the previous job:

    rate              = [5, 10, 15, 20];
    request_rate      = [5.1, 9.3, 12.9, 15.8];
    connection_rate   = [5.1, 9.3, 12.9, 15.8];
    reply_rate_avg    = [0.0, 0.0, 0.0, 0.0];
    reply_rate_max    = [0.0, 0.0, 0.0, 0.0];
    reply_time        = [88.4, 93.4, 89.2, 89.1];
    reply_rate_stddev = [0.0, 0.0, 0.0, 0.0];
    errors            = [0, 0, 0, 0];

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

    axis([0 20 0 20]);
    title('Hansel report for www.example.com:80/ (10 connections per run)')
    xlabel('Demanded Request Rate');
    legend('Request Rate', 'Connection Rate', 'Avg. reply rate', 'Max. reply rate', 'Reply rate StdDev', 'Reply time', 'Errors');
    print('/Users/paulm/hansel_output/hansel-10.m.png', '-dpng')
    
Run octave on it will produce graph as a png file.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## References

"HTTP Perforance Testing with httperf":http://agiletesting.blogspot.com/2005/04/http-performance-testing-with-httperf.html
"Perforance vs Load Testing":http://agiletesting.blogspot.com/2005/04/more-on-performance-vs-load-testing.html

## Copyright

Copyright (c) 2010 Paul Mylchreest. See LICENSE for details.
