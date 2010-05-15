module HanselCore
  #
  # Output to yaml format
  #
  class YamlFormatter
    def self.format results
      results.to_yaml
    end
  end
end