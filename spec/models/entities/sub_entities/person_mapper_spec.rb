require "spec_helper"

describe Entities::SubEntities::PersonMapper do

  subject{ Entities::SubEntities::PersonMapper}

  let(:organization) { create(:organization)}

  describe 'normalize' do
    let(:connec_hash) {
      {
        "first_name" => "John",
        "title" => "Mr",
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
      { :data => {
        :title => 'Mr',
        :first_name => 'John',
        :address => {
          :city => 'London',
          :postal_code => 'W6 7TN',
          :country => 'United Kingdom'
          }
        }
      }
    }

    it { expect(subject.normalize(connec_hash)).to eql(mapped_connec_hash) }
  end

  describe 'denormalize' do

    let(:external_hash) {
      {
      "data"=> {
        "id"=> 134706023,
        "contact_id"=> nil,
        "first_name"=> "John",
        "last_name"=> "Smith",
        "title"=> "Mr",
        "email"=> 'test@email.com',
        "address" => {
            "city" => "London",
            "postal_code" => "W6 7TN",
            "country" => "United Kingdom"
        }
      }
    }
  }

    let (:mapped_external_hash) {
      {
        :first_name => "John",
        :last_name => "Smith",
        :title => "Mr",
        :email => {
          :address => "test@email.com"
          },
        :address_work => {
          :billing => {
            :city => 'London',
            :postal_code => 'W6 7TN',
            :country => 'United Kingdom'
          }
        }
      }
    }

    it { expect(subject.denormalize(external_hash)).to eql(mapped_external_hash) }
  end
end
