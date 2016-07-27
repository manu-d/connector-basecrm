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
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end

  def self.references
    %w(lead_id)
  end

  def before_sync(last_synchronization_date = nil)
     @stages = @external_client.get_entity('stages')
  end

  def map_to_connec(entity)
    mapped_entity = super
    stage = @stages.find { |stage| stage['id'] == entity['stage_id'] }
    mapped_entity[:sales_stage] = stage['name'] ? stage['name'] : "stage not found"
    mapped_entity[:probability] = stage['likelihood'] ? stage['likelihood'] : 0
    mapped_entity
  end

  def map_to_external(entity)
     mapped_entity = super
     stage = @stages.find { |stage| stage['name'].downcase == entity['sales_stage'].downcase}
     stage ||= @stages.find { |stage| stage['likelyhood'] == entity['probability']}
     mapped_entity[:stage_id] = stage ? stage['id'] : 0
     mapped_entity
  end
end

class OpportunityMapper
  extend HashMapper

  #map from Connec! to Base
  map from('name'), to('name')
  map from('amount/total_amount', &:to_f), to('value') { |value| value.is_a?(Integer) ? value : value.to_s }

  map from('sales_stage'), to('stage_id')
  map from('expected_close_date'), to('estimated_close_date')
  map from('sales_stage_changes[0]/created_at'), to('last_stage_change_at')

  map from('lead_id'), to('contact_id')
end
