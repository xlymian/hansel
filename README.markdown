hansel
======

Hansel is a pure ruby driver for httperf for automated load and performance testing. It will load 
a job queue file, in a yaml format, run httperf with each job

Installing Httperf and Hansel
-----------------------------

## Httperf

For Linux (Ubuntu):

    apt-get update && apt-get -y install rubygems httperf ruby1.8-dev libcurl4-gnutls-dev
    gem install rubygems-update -v 1.3.0
    export PATH=$PATH:/var/lib/gems/1.8/bin
    update_rubygems
    gem update --system
    gem install hansel

On MacOS X using homebrew:

    brew install httperf
    gem install hansel


## Optional -- Installing Octave (warning: long!)

    brew install gfortran octave

or with MacPorts:

    sudo port install octave

Example usage
-------------

Create a job queue file in ~/.hansel/jobs.yml:

    ---
      - :server: www.example.com
        :uri: /
        :num_conns: 50
        :low_rate: 10
        :high_rate: 50
        :rate_step: 10
        :description: example

      - :server: www.apple.com
        :uri: /
        :num_conns: 50
        :low_rate: 10
        :high_rate: 50
        :rate_step: 10
        :description: apple

and run Hansel

    hansel --verbose --format=octave

By default, the output is written into the ~/hansel_output directory. When the octave format is
specified, it uses the default template octave.m.erb in the project templates. Here is a sample
output from the previous job:

    rate              = [10, 20, 30, 40, 50];
    request_rate      = [8.8, 17.6, 18.9, 24.6, 19.3];
    connection_rate   = [8.8, 17.6, 18.9, 24.6, 19.3];
    reply_rate_avg    = [0.0, 0.0, 0.0, 0.0, 0.0];
    reply_rate_max    = [0.0, 0.0, 0.0, 0.0, 0.0];
    reply_time        = [62.7, 56.0, 55.8, 45.3, 118.0];
    reply_rate_stddev = [0.0, 0.0, 0.0, 0.0, 0.0];
    errors            = [0, 0, 0, 0, 0];

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

    axis([0 50 0 50]);
    title('Hansel report for www.apple.com:80/  (10 connections per run)')
    xlabel('Demanded Request Rate');
    legend('Request Rate', 'Connection Rate', 'Avg. reply rate', 'Max. reply rate', 'Reply rate StdDev', 'Reply time', 'Errors');
    print('www.apple.com-80-osx-10.png', '-dpng')

Run octave on it will produce graph as a png file.

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Meta
----

* Code: `git clone git://github.com/xlymian/hansel.git`
* Home: <http://github.com/xlymian/hansel>
* Docs: <http://defunkt.github.com/resque/>
* Bugs: <http://github.com/xlymian/hansel/issues>

References
----------

* HTTP Perforance Testing with httperf: <http://agiletesting.blogspot.com/2005/04/http-performance-testing-with-httperf.html>

Copyright
---------
Copyright (c) 2009 Paul Mylchreest. See LICENSE for details.
