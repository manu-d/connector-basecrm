class DataParser
  def initialize
    @output_to_connec = []
    @output_to_base = { "data" => {}}
  end

  def from_base_collection(entities)
    array = JSON.parse(entities)['items']
    array.each { |entity| @output_to_connec << entity['data']}
    @output_to_connec
  end

  def from_base_single(entity)
    output = JSON.parse(entity)
    output['data']
  end

  def to_base(entity)
    @output_to_base['data'] = entity
    @output_to_base
  end
end
