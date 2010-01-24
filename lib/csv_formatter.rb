require 'csv'

class CsvFormatter
  def initialize(data)
    @data = data
  end

  def format
    result = ""
    return result if @data.empty?
    keys = @data[@data.keys.first].keys
    result << CSV.generate_line(keys.map(&:to_s))
    result << "\n"
    @data.each_pair do |key, value|
      result << CSV.generate_line(keys.collect{|k| value[k]})
      result << "\n"
    end
    result
  end
end
