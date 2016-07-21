class DataParser

  def from_base_collection(entities)
    # array = JSON.parse(entities)['items']
    # array.each { |entity| @output_to_connec << entity['data']}
    # @output_to_connec
    JSON.parse(entities)['items'].map { |entity| entity['data'] }
  end

  def from_base_single(entity)
    output = JSON.parse(entity)
    output['data']
  end

  def to_base(entity)
    { "data" => entity}
  end

  def pagination(response)
    response
  end
end
