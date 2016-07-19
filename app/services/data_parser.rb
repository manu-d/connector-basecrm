class DataParser
  def initialize
    @output_to_connec = []
    @output_to_base = { "data" => {}}
  end

  def from_base(entities)
    array = JSON.parse(entities)['items']
    array.each { |entity| @output_to_connec << entity['data']}
    @output_to_connec
  end

  def to_base(entity)
    @output_to_base['data'] = entity
    @output_to_base
  end
end
