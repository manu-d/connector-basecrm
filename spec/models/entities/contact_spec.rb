require 'spec_helper'

describe Entities::Contact do

describe 'class methods' do
  subject { Entities::Contact }

  it { expect(subject.connec_entity_name).to eql('Person') }
  it { expect(subject.external_entity_name).to eql('Contact') }
  it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'A', 'last_name' => 'contact'})).to eql('A contact') }
  it { expect(subject.object_name_from_external_entity_hash({'first_name' => 'A', 'last_name' => 'contact'})).to eql('A contact') }
end

describe 'instance methods' do
  before do
    allow(BaseCRM::Client).to receive(:new) { "test client"}
  end
  let(:organization) { create(:organization) }
  let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
  let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
  let(:opts) { {} }
  subject { Entities::Contact.new(organization, connec_client, external_client, opts) }

  describe 'external to connec!' do
    let(:external_hash) {
      {
      "data"=> {
        "id"=> 1,
        "contact_id"=> null,
        "name"=> "Design Services Company",
        "first_name"=> null,
        "last_name"=> null,
        "customer_status"=> "none",
        "prospect_status"=> "none",
        "title"=> null,
        "email"=> null
    }
  }
}

    let (:mapped_external_hash) {   #to connec!
      {
        "id" => [{'id' => '2345uoi', 'provider' => organization.oauth_provider, 'realm' => organization.oauth_uid}],
        "first_name" => "John",
        "title" => "Mr",
        "address_work" => {
          "billing2" => {
            "city" => 'London'
          }
        }
      }.with_indifferent_access
    }

    it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
  end

  describe 'connec to external' do
    let(:connec_hash) {
      {
        "first_name" => "John",
        "title" => "Mr",
        "address_work" => {
          "billing2" => {
            "city" => 'London'
          }
        }
      }
    }

    let(:mapped_connec_hash) {
      {
        "Salutation" => 'Mr',
        "FirstName" => 'John',
        "City" => 'London'
      }.with_indifferent_access
    }

    it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
  end
end
end
