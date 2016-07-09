class Entities::Person < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Person'
  end

  def self.external_entity_name
    'Contact'
  end

  def self.mapper_class
    PersonMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    "#{entity['data']['first_name']} #{entity['data']['last_name']}"
  end
end

class PersonMapper
  extend HashMapper

  map from('id'), to('data/id')
  map from('updated_at'), to('data/updated_at')
  map from('created_at'), to('data/created_at')
  map from('title'), to('data/title')
  map from('first_name'), to('data/first_name')
  map from('last_name'), to('data/last_name')
  map from('email'), to('data/email')

  map from('address_work/billing/line1'), to('data/address/line1')
  map from('address_work/billing/city'), to('data/address/city')
  map from('address_work/billing/postal_code'), to('data/address/postal_code')
  map from('address_work/billing/region'), to('data/address/state')
  map from('address_work/billing/country'), to('data/address/country')

  map from('/status'), to('/customer_status')
end
