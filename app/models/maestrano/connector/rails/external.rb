class Maestrano::Connector::Rails::External
  include Maestrano::Connector::Rails::Concerns::External

  def self.external_name
    "BaseCRM"
  end

  def self.get_client(organization)
    BaseCRM::Client.new access_token: organization.oauth_token
    # refresh_token: organization.refresh_token,
    # instance_url: organization.instance_url,
  end

  # Return an array of all the entities that the connector can synchronize
  # If you add new entities, you need to generate
  # a migration to add them to existing organizations
  def self.entities_list
    # TODO
    # The names in this list should match the names of your entities class
    # e.g %w(person, tasks_list)
    #  will synchronized Entities::Person and Entities::TasksList
    []
  end

  def self.fetch_company(organization)
    client = BaseCRM::Client.new access_token: organization.oauth_token
    response = client.accounts.self    
  end
end
