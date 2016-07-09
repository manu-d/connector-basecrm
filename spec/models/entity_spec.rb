require 'spec_helper'

describe Maestrano::Connector::Rails::Entity do

  describe 'class methods' do
    subject { Maestrano::Connector::Rails::Entity }

    describe 'id_from_external_entity_hash' do
      it { expect(subject.id_from_external_entity_hash({"data" => {'id' => '1234'}})).to eql('1234') }
    end

    describe 'last_update_date_from_external_entity_hash' do
      it {
        Timecop.freeze(Date.today) do
          expect(subject.last_update_date_from_external_entity_hash({"data" => {'updated_at' => 1.hour.ago.to_s}})).to eql(1.hour.ago.to_s)
        end
      }
    end

    describe 'creation_date_from_external_entity_hash' do
      Timecop.freeze(Date.today) do
        it { expect(subject.creation_date_from_external_entity_hash({"data" => {'created_at' => 3.hour.ago.to_s}})).to eql(3.hour.ago.to_s) }
      end
    end

    describe 'inactive_from_external_entity_hash?' do
      it { expect(subject.inactive_from_external_entity_hash?({"data" => {'customer_status' => 'past'}})).to eql(true) }
    end

  end

  describe 'instance methods' do

    let(:organization) { create(:organization) }
    let(:client) { BaseAPIManager }
    let(:external_name) { 'external_name' }
    subject { Maestrano::Connector::Rails::Entity.new(organization, nil, client) }
    before {
      allow(subject.class).to receive(:external_entity_name).and_return(external_name)
      allow(subject.class).to receive(:external_attributes).and_return(%w(FirstName LastName))
      allow(RestClient::Request).to receive(:execute) { "test http request"}
      allow(JSON).to receive(:parse) { {"items" => "parsed entity hash"}}
    }
    describe 'get_external_entities' do

      it 'uses RestCient::Request to query the external API' do
        subject.get_external_entities(nil)
      end

      it 'returns the entities' do
        expect(subject.get_external_entities(nil)).to eq "parsed entity hash"
      end
    end


    describe 'create_external_entity' do
      it 'Uses RestClient to post a new entity' do
        expect(subject.create_external_entity({}, external_name)).to eq 'test http request'
      end
    end

    describe 'update_external_entity' do
      it 'calls update with the id' do
        expect(subject.update_external_entity({}, '3456', external_name)).to eq "test http request"
      end
    end
  end
end
