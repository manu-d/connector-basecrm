require 'spec_helper'

describe Entities::SubEntities::Person do

  context "Class Methods" do
    subject { Entities::SubEntities::Person }

    it { expect(subject.entity_name).to eql('Person') }
    it { expect(subject.external?).to eql(false) }
    it { expect(subject.mapper_classes).to eql({"Contact" => Entities::SubEntities::PersonMapper}) }
    it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'A', 'last_name' => 'contact'})).to eql('A contact') }
  end

  context "Instance Methods" do

    let(:organization) { create(:organization)}
    subject { Entities::SubEntities::Person.new(organization, nil, nil)}

    describe '#map_to external' do
      let(:connec_hash) {
        {
          "first_name" => "John",
          "job_title" => "CTO",
          "contact_channel" => {
            "skype" => "johnsmith"
          },
          "phone_work" => {
            "landline" => "0208111111",
            "mobile" => "0777111222",
            "fax" => "0208000000"
          },
          "address_work" => {
            "billing" => {
              "city" => 'London',
              "postal_code" => "W6 7TN",
              "country" => "United Kingdom"
            }
          }
        }
      }

      let(:mapped_connec_hash) {
        { :title => 'CTO',
          :first_name => 'John',
          :skype => 'johnsmith',
          :phone => '0208111111',
          :mobile => '0777111222',
          :fax => '0208000000',
          :address => {
            :city => 'London',
            :postal_code => 'W6 7TN',
            :country => 'United Kingdom'
          }
        }.with_indifferent_access
      }

      it { expect(subject.map_to('Contact', connec_hash)).to eql(mapped_connec_hash) }
    end
  end
end
