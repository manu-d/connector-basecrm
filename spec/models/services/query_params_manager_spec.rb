require "spec_helper"

describe QueryParamsManager do
  it "Is a singleton model" do
    expect{ QueryParamsManager.new}.to raise_error NoMethodError
  end

  it "Uses URI to parse authorization params" do
    auth_params = {
      state: "uid-123",
      test: "test-123"
    }
    expect(QueryParamsManager.query_params(auth_params)).to eq "state=uid-123&test=test-123"
  end
end
