require 'spec_helper'
#The arguments for the stubbed RestClient::Request are hardcoded into this file
require 'api_manager_helper'

describe BaseAPIManager do

  context "Uses RestClient to query the BaseCRM API:" do

    before do
      @organization = build(:organization, uid: nil, oauth_token: nil, refresh_token: nil, oauth_provider: nil)
      # BaseClient#get_entities parses the response using JSON.parse
      allow(JSON).to receive(:parse) { {"items" => "parsed response"}}
    end
    it "can retrieve entities" do
      allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_get) { "test http request"}
      expect(BaseAPIManager.new(@organization).get_entities("entity")).to eq "parsed response"
    end

    it "can create entities" do
      allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_post) { "test post request"}
      expect(BaseAPIManager.new(@organization).create_entities({"payload" => "test"}, "contact")).
        to eq ("test post request")
    end

    it "can update entities" do
      allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_put) { "test put request"}
      expect(BaseAPIManager.new(@organization).update_entities({"payload" => "test"}, "1", "contact")).
        to eq ("test put request")
    end
  end
end
