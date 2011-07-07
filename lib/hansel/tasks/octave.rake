require 'ostruct'
require 'hansel/formatting/octave_formatter.rb'

namespace :hansel do
  namespace :octave do
    # rake hansel:octave:plot[input_file,output_dir]
    desc "Generate octave multiplots for an input yaml file"
    task :plot, :input_file, :output_dir do |t, args|
      desc "Generate octave plot for a file"
      data = YAML.load_file( args.input_file ).collect{ |o| OpenStruct.new o.ivars }
      template = File.join( [ File.dirname(__FILE__),
                              '../../../templates',
                              'multiplot.m.erb' ] )
      first = data.first
      output_dir = args.output_dir
      output_name = args.input_file.split('/').last.gsub( '.', '_') + '.m'
      output_file = File.join([ output_dir, output_name ])
      File.open( output_file, 'w+' ) do |output|
        output.puts HanselCore::OctaveFormatter.new(data,
            { :output_file_name => output_name,
              :template         => template,
              :description      => first.description,
              :png_file_name    => [  first.server,
                                      first.port,
                                      first.description,
                                      first.num_conns.to_s
                                   ].compact.join('_')
            }).format
      end
    end

    # rake hansel:octave:run[input_dir,input_file]
    desc "Run octave on the specified file"
    task :run, :input_dir, :input_file do |t, args|
      %x[ cd #{args.input_dir} && octave #{args.input_file} ]
    end
  end
end
