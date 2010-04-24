module Hansel
  #
  # Output to yaml format
  #
  class YamlFormatter
    def initialize(data)
      @data = data
    end

    def format
      @data.to_yaml
    end
  end
end