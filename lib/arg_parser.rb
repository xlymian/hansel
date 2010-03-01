class ArgParser
  # http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
  # Return a structure describing the options.
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options               = OpenStruct.new
    options.verbose       = false
    options.server        = 'localhost'
    options.port          = '80'
    options.uri           = '/'
    options.num_conns     = 1
    options.rate          = 1
    options.cookie        = nil
    options.low_rate      = 1
    options.high_rate     = 2
    options.rate_step     = 1
    options.output_format = :yaml
    options.output        = nil
    options.output_dir    = File.join ENV['HOME'], 'hansel_output'
    options.exit          = false

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: hansel [options]"

      opts.separator "Specific options:"

      # Mandatory argument.
      opts.on("-s", "--server=S",
              "Specifies the IP hostname of the server.") do |opt|
        options.server = opt
      end

      opts.on("-p", "--port=N",
              "This option specifies the port number N on which the web server is listening for HTTP requests.") do |opt|
        options.port = opt
      end

      opts.on("-u", "--uri=S",
              "Specifies that URI S should be accessed on the server.") do |opt|
        options.uri = opt
      end

      opts.on("-n", "--num_conns=N",
              "Specifies the total number of connections to create.") do |opt|
        options.num_conns = opt.to_i
      end

      opts.on("-l", "--low_rate=S",
              "Specifies the starting fixed rate at which connections are created.") do |opt|
        options.low_rate = opt.to_i
      end

      opts.on("-l", "--high_rate=S",
              "Specifies the ending fixed rate at which connections are created.") do |opt|
        options.high_rate = opt.to_i
      end

      opts.on("-l", "--rate_step=S",
              "Specifies the fixed rate step at which connections are created.") do |opt|
        options.rate_step = opt.to_i
      end

      opts.on("-c", "--cookie=C", "Specify a cookie.") do |opt|
        options.cookie = opt
      end

      opts.on("-f", "--format=FILE [yaml|csv]", "Specify an output format.") do |opt|
        options.output_format = opt.to_sym
      end

      opts.on("-o", "--output=FILE", "Specify an output file.") do |opt|
        options.output = opt
      end

      opts.on("-d", "--output_dir=PATH", "Specify an output directory.") do |opt|
        options.output_dir = opt
      end

      opts.separator "Common options:"

      # Boolean switch.
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |opt|
        options.verbose = opt
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        options.exit = true
      end

      opts.on_tail("--version", "Show version") do
        puts "Hansel version #{IO.foreach('VERSION').first.strip}"
        options.exit = true
      end
    end

    opts.parse!(args)
    options
  end
end
