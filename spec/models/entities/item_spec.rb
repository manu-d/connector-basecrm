require 'spec_helper'

describe Entities::Item do

describe 'class methods' do
  subject { Entities::Item }

  it { expect(subject.connec_entity_name).to eql('Item') }
  it { expect(subject.external_entity_name).to eql('Product') }
  it { expect(subject.object_name_from_connec_entity_hash({'name' => 'A'})).to eql('A') }
  it { expect(subject.object_name_from_external_entity_hash({'name' => 'A'})).to eql('A') }
end

describe 'instance methods' do
  
  let(:organization) { create(:organization) }
  let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
  let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
  let(:opts) { {} }
  subject { Entities::Item.new(organization, connec_client, external_client, opts) }

  describe 'external to connec!' do
    let(:external_hash) {
        {
          "id" => 1,
          "name" => "Cloud Service",
          "sku" => "cloud-sku",
          "description" => "Amazing Service",
          "prices" => [
            {
              "amount" => "1599.99",
              "currency" => "GBP"
            }
          ],
          "cost" => "799.99",
          "cost_currency" => "GBP",
          "created_at" => "2014-11-30T08:14:44Z",
          "updated_at" => "2014-11-30T08:14:44Z"
        }
      }

    let (:mapped_external_hash) {
      {
        "id" => [{'id' => 1, 'provider' => organization.oauth_provider, 'realm' => organization.oauth_uid}],
        "name" => "Cloud Service",
        "reference" => "cloud-sku",
        "description" => "Amazing Service",
        "sale_price" => {
          "total_amount" => 1599.99,
          "currency" => "GBP"
        },
        "purchase_price" => {
          "total_amount" => 799.99,
          "currency" => "GBP"
        }
      }.with_indifferent_access
    }

    it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
  end

  describe 'connec to external' do
    let(:connec_hash) {
      {
      "name" => "Cloud Service",
      "reference" => "cloud-sku",
      "description" => "Amazing Service",
      "sale_price" => {
        "total_amount" => 1599.99,
        "currency" => "GBP"
      },
      "purchase_price" => {
        "total_amount" => 110,
        "currency" => "GBP"
      },
      "created_at" => "2014-11-30T08:14:44Z",
      "updated_at" => "2014-11-30T08:14:44Z"
    }
  }

    let(:mapped_connec_hash) {
      {
        "name" => "Cloud Service",
        "sku" => "cloud-sku",
        "description" => "Amazing Service",
        "prices" => [
          {
            "amount" => "1599.99",
            "currency" => "GBP"
          }
        ],
        "cost" => "110",
        "cost_currency" => "GBP"
      }.with_indifferent_access
    }

    it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
  end
 end
end
