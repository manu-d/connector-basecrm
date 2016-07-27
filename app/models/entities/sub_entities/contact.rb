class Entities::SubEntities::Contact < Maestrano::Connector::Rails::SubEntityBase

  def self.external?
    true
  end

  def self.entity_name
    'Contact'
  end

  def self.mapper_classes
    {
      'Person' => Entities::SubEntities::PersonMapper,
      'Organization' => Entities::SubEntities::OrganizationMapper
    }
  end

  def self.references
    {
      'Person' => %w(organization_id, assignee_id)
    }
  end

  def self.object_name_from_external_entity_hash(entity)
    if entity['is_organization']
      entity['name']
    else
      "#{entity['first_name']} #{entity['last_name']}"
    end
  end
end
