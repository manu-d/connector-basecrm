require "spec_helper"

describe BaseClient do

  it "Stores the URI for the callback" do
    expect(BaseClient::RED_URI).to match /^https.+\/auth\/baseCRM\/callback/
  end

  it "Has a method #authorize that instantiates a OAuth2 object" do
    auth_params = { state: 'uid-123'}
    expect(BaseClient.authorize(auth_params)).to be_a OAuth2::Client
  end

  it "Can be used to request a OAuth authorization code" do
    auth_params = { state: 'uid-123'}
    expect(BaseClient.authorize(auth_params).auth_code.authorize_url).to match /^https:\/\/api.getbase.com\/oauth2\/authorize\?client_id.+response_type=code.+/
  end

  it "Can be used to obtain an OAuth token" do
    expect(BaseClient.obtain_token.token_url).to eq "https://api.getbase.com/oauth2/token"
  end

  context "Uses RestClient to query the BaseCRM API:" do
    before do
      @organization = build(:organization, uid: nil, oauth_token: nil, refresh_token: nil, oauth_provider: nil)
      #RestClient is called internally by BaseClient every instance method invocation.
      allow(RestClient::Request).to receive(:execute) { "test http request"}
      # BaseClient#get_entities parses the response using JSON.parse
      allow(JSON).to receive(:parse) { {"items" => "parsed response"}}
    end
    it "can retrieve entities" do
        expect(BaseClient.new(@organization).get_entities("entity")).to eq "parsed response"
    end

    it "can create entities" do
      expect(BaseClient.new(@organization).create_entities({"mapped_connec_entity" => "test"}, "contact")).
        to eq ("test http request")
    end

    it "can update entities" do
      expect(BaseClient.new(@organization).update_entities({"mapped_connec_entity" => "test"}, "1", "contact")).
        to eq ("test http request")
    end
  end
end
