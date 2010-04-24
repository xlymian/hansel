require 'csv'
module Hansel
  #
  # Output to csv format
  #
  class CsvFormatter
    def initialize(data)
      return if data.empty?
      @data = data
      @csv = ""
      @info_keys = []
      @data_keys = []
      @data.keys.each do |key|
        @info_keys << key if key.instance_of? Symbol
        @data_keys << key if key.instance_of? Fixnum
      end
      @keys ||= @data[@data_keys.first].keys
      @info = @info_keys.collect{|key| @data[key]}
      line header
    end

    def line text
      @csv << text
      @csv << "\n"
    end

    def header
      @header ||= CSV.generate_line((@info_keys + @keys).map(&:to_s))
    end

    def format_line data_key
      line CSV.generate_line(@info + @keys.collect{|key| @data[data_key][key]})
    end

    def format
      return result if @data.empty?
      @data_keys.each { |data_key| format_line data_key }
      @csv
    end
  end
end
