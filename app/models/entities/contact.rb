class Entities::Contact < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Person'
  end

  def self.external_entity_name
    'Contact'
  end

  def self.mapper_class
    ContactMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end
end

class ContactMapper
  extend HashMapper

  map from('/id'), to('/id')
  map from('/group_id'), to('contact_id')
  map from('/updated_at'), to('/updated_at')
  map from('/created_at'), to('/created_at')
  map from('/title'), to('/title')
  map from('/first_name'), to('/first_name')
  map from('/last_name'), to('/last_name')
  map from('/email'), to('/email')
  map from('/address_work'), to('/address')
  map from('/status'), to('/customer_status')
end
