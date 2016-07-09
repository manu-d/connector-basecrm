require 'spec_helper'

describe BaseAPIManager do

  context "Uses RestClient to query the BaseCRM API:" do

    before do
      @organization = build(:organization, uid: nil, oauth_token: nil, refresh_token: nil, oauth_provider: nil)
      #RestClient is called internally by BaseClient every instance method invocation.
      allow(RestClient::Request).to receive(:execute) { "test http request"}
      # BaseClient#get_entities parses the response using JSON.parse
      allow(JSON).to receive(:parse) { {"items" => "parsed response"}}
    end
    it "can retrieve entities" do
        expect(BaseAPIManager.new(@organization).get_entities("entity")).to eq "parsed response"
    end

    it "can create entities" do
      expect(BaseAPIManager.new(@organization).create_entities({"mapped_connec_entity" => "test"}, "contact")).
        to eq ("test http request")
    end

    it "can update entities" do
      expect(BaseAPIManager.new(@organization).update_entities({"mapped_connec_entity" => "test"}, "1", "contact")).
        to eq ("test http request")
    end
  end
end
