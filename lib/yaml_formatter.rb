class YamlFormatter
  def initialize(data)
    @data = data
  end

  def format
    @data.to_yaml
  end
end
