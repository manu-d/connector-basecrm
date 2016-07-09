
class Entities::Item < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Item'
  end

  def self.external_entity_name
    'Product'
  end

  def self.mapper_class
    ItemMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['data']['name']
  end
end

class ItemMapper
  extend HashMapper

  map from('/id'), to('/id')
  map from('/name'), to('/name')
  map from('/updated_at'), to('/updated_at')
  map from('/created_at'), to('/created_at')
  map from('/reference'), to('/sku')
  map from('/description'), to('/description')
  map from('/purchase_price'), to('/cost')
end
