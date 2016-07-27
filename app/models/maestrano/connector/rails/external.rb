class Maestrano::Connector::Rails::External
  include Maestrano::Connector::Rails::Concerns::External

  def self.external_name
    "BaseCRM"
  end

  def self.get_client(organization)
    BaseAPIManager.new(organization)
  end

  def self.entities_list
    %w(person_and_organization item opportunity)
  end

  def self.fetch_company(organization)
    client = BaseAPIManager.new(organization).get_account
  end
end
