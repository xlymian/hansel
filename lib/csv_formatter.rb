require 'csv'

module Hansel

  # Output to csv format
  #
  class CsvFormatter
    COLUMNS = %w(rate replies connection_rate request_rate reply_time net_io
                  errors status reply_rate_min reply_rate_avg reply_rate_max
                  reply_rate_stddev)

    def initialize(data)
      @data = data
      @csv = ""
    end

    def line text
      @csv << text
      @csv << "\n"
    end

    def format_line data
      line CSV.generate_line( COLUMNS.map { |column| data.send column.to_sym } )
    end

    def format
      line CSV.generate_line(COLUMNS)
      @data.each { |data| format_line data } unless @data.empty?
      @csv
    end
  end
end
