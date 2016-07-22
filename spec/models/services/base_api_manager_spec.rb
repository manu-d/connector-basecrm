require 'spec_helper'

describe BaseAPIManager do

  let(:organization) { build(:organization, uid: nil, oauth_token: nil, refresh_token: nil, oauth_provider: nil) }


  context "Uses RestClient to query the BaseCRM API:" do

    before do
      allow(DataParser).to receive(:from_base_collection) { ["Parsed Response"]}
      allow(DataParser).to receive(:from_base_single) { "Parsed Response"}
      allow(DataParser).to receive(:to_base) { "Parsed Response"}
      allow(JSON).to receive(:parse) { {"meta" => {"links" => "https://test.com"}}}
      allow(JSON).to receive(:generate) { "Generated JSON"}
    end

    #The API manager gets rid of the 'data' field before returning the array of entities
    it "Returns a response from the API" do
      allow(RestClient).to receive(:get) { :TEST}
      output = BaseAPIManager.new(organization).get_entities("contact")
      expect(output).to eq ["Parsed Response"]
    end

    it "can create entities" do
      allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_post) { "test post request"}
      expect(BaseAPIManager.new(organization).create_entities({"payload" => "test"}, "contact")).
        to eq "Parsed Response"
    end

    context "#update_entities" do

      it "can update entities" do
        allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_put) { "test put request"}
        expect(BaseAPIManager.new(organization).update_entities({"payload" => "test"}, "1", "contact")).
          to eq "Parsed Response"
      end

      it "raises a custom exception when an entity is not found" do
        allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_put) { raise RestClient::ResourceNotFound.new}
        expect{ BaseAPIManager.new(organization).update_entities({"payload" => "test"}, "1", "contact")}.
          to raise_error { Exceptions::RecordNotFound.new}
      end
    end
  end
end
