require 'ostruct'
require 'hansel/formatting/octave_formatter.rb'

namespace :octave do
  # rake octave:plot
  task :plot, :file do |t, args|
    desc "Generate octave plot for a file"
    data = YAML.load_file( args.file ).collect{ |o| OpenStruct.new o.ivars }
    template = File.join( [ File.dirname(__FILE__),
                            '../../templates',
                            'octave.m.erb' ] )
    first = data.first
    puts HanselCore::OctaveFormatter.new(data,
        { :output_file_name => first.file_name,
          :template         => template,
          :description      => first.description,
          :png_file_name    => [  first.server,
                                  first.port,
                                  first.description,
                                  first.num_conns.to_s
                               ].compact.join('-')
        }).format
  end
end
