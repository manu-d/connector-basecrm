require 'spec_helper'

describe OrganizationManager do

    before do
      @organization = build(:organization, uid: nil, oauth_token: nil, refresh_token: nil, oauth_provider: nil)
      @token = OpenStruct.new(token: "NEW", refresh_token: "NEW")
      allow(Maestrano::Connector::Rails::External).to receive(:fetch_company) { @company = OpenStruct.new(id: "NEW")}
      allow_any_instance_of(Organization).to receive(:update) { "test"}
    end

  it "Can store an organization" do
    manager = OrganizationManager.new(@organization, @token)
    expect(manager.show_organization).to be_a Organization
  end

  context "#update" do
    it "updates the organization details" do
      OrganizationManager.update(@organization, @token)
      expect(@organization.oauth_token).to eq 'NEW'
      expect(@organization.refresh_token).to eq 'NEW'
      expect(@organization.refresh_token).to eq 'NEW'
      expect(@organization.oauth_provider).to eq 'Base'
    end
  end
end
