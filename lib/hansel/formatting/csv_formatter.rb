require 'csv'

module HanselCore

  # Output to csv format
  #
  class CsvFormatter
    COLUMNS = %w(server port num_conns rate replies connection_rate request_rate reply_time net_io
                  errors status reply_rate_min reply_rate_avg reply_rate_max reply_rate_stddev)

    def self.line text
      @csv << text
      @csv << "\n"
    end

    def self.format_line data
      line CSV.generate_line( COLUMNS.map { |column| data.send column.to_sym } )
    end

    def self.format results
      @csv = ""
      line CSV.generate_line(COLUMNS)
      results.each { |data| format_line data } unless results.empty?
      @csv
    end
  end
end
