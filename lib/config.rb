module Config
  def config_path
    config_path ||= File.join [ENV['HOME'], '.hansel']
  end

  def options_path
    options_path ||= File.join config_path, 'options'
  end

  def read_config_file
    args = []
    FileUtils.mkdir_p config_path unless File.exists? config_path
    if File.exists? options_path
      File.open options_path do |file|
        file.read.split("\n").each do |line|
          next if line =~ /#+/
          args += line.split(' ')
        end
      end
    end
    args
  end

  def options
    @opt ||= ArgParser.parse(read_config_file + ARGV)
  end
end
