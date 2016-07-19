require "spec_helper"
require "data_helper"

describe DataParser do

  subject        { DataParser.new}
  let(:response) { api_get_call_contacts}
  let(:mapped_entity) { mapped_connec_entity}

  describe '#from_base' do
    it "parses the response as an array" do
      expect(subject.from_base(response)).to be_an Array
    end

    it "parses the response filtering 'item' and 'data' fields " do
      expect(subject.from_base(response)[0]['id']).to eq 135906739
    end
  end

  describe "#to_base" do
    it "parses the response as an Hash" do
      expect(subject.to_base(mapped_entity)).to be_an Hash
    end

    it "parses the response adding the 'data' field" do
      output = subject.to_base(mapped_entity)
      expect(output['data']).not_to be nil
    end
  end

end
