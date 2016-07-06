class OrganizationManager
  def initialize(organization, token)
    @organization = organization
    @token = token
  end

  #The sevice updates the organization oauth_uid, oauth_token, refresh_token and oauth_provider fields. 
  def self.update(organization, token)
    new(organization, token)
    organization.from_omniauth(token)
    company = Maestrano::Connector::Rails::External.fetch_company(organization)
    organization.update(oauth_uid: company.id)
  end

  private
  attr_reader :organization, :token
end
