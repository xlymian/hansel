module Mutter
  begin
    require 'mutter'
  rescue LoadError
    STDERR.puts "mutter gem wasn't found, using default output."
  end

  def mutter
    mutter ||= Mutter.new({
      :underline => %w'( )', :yellow => %w'[ ]',
      :bold      => %w'< >'
    }).clear(:default)
  rescue
    nil
  end
end