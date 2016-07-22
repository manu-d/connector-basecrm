require 'singleton'

class DataParser
  include Singleton
  
  def self.from_base_collection(entities)
    # array = JSON.parse(entities)['items']
    # array.each { |entity| @output_to_connec << entity['data']}
    # @output_to_connec
    JSON.parse(entities)['items'].map { |entity| entity['data'] }
  end

  def self.from_base_single(entity)
    output = JSON.parse(entity)
    output['data']
  end

  def self.to_base(entity)
    { "data" => entity}
  end
end
