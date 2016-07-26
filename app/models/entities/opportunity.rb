class Entities::Opportunity < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Opportunity'
  end

  def self.external_entity_name
    'Deal'
  end

  def self.mapper_class
    OpportunityMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    "#{entity['name']}"
  end
end

class OpportunityMapper
  extend HashMapper

  after_normalize do |input, output|
  end

  #map from Connec! to Base
  map from('name'), to('name')
  map from('description'), to('description'), default: "This deal has no description"
  map from('amount/total_amount', &:to_i), to('value') { |value| value.is_a?(Integer) ? value : value.to_s }

  map from('sales_stage'), to('stage_id')
  map from('expected_close_date'), to('estimated_close_date')
  map_from('sales_stage_changes[0]/created_at'), to('last_stage_change_at')

  map_from('lead_id'), to('contact_id')

  map from(

end
