require 'ostruct'
require 'hansel/formatting/octave_formatter.rb'

namespace :octave do
  # rake octave:plot
  task :plot, :input, :output do |t, args|
    desc "Generate octave plot for a file"
    data = YAML.load_file( args.input ).collect{ |o| OpenStruct.new o.ivars }
    template = File.join( [ File.dirname(__FILE__),
                            '../../templates',
                            'multiplot.m.erb' ] )
    first = data.first
    File.open(args.output, 'w+') do |output|
      output.puts HanselCore::OctaveFormatter.new(data,
          { :output_file_name => first.file_name,
            :template         => template,
            :description      => first.description,
            :png_file_name    => [  first.server,
                                    first.description,
                                    first.num_conns.to_s
                                 ].compact.join('-')
          }).format
    end
  end
end
