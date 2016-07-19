require 'bigdecimal'

class Entities::Item < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Item'
  end

  def self.external_entity_name
    'Product'
  end

  def self.mapper_class
    ItemMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    "#{entity['name']}"
  end
end

class ItemMapper
  extend HashMapper

  after_normalize do |input, output|
    output['sku'] = input['reference'].present? ? input['reference'] : "NOSKU-#{(1..9).to_a.shuffle[0,5].join}"
    output['cost'] = input['purchase_price']['total_amount'].present? ? input['purchase_price']['total_amount'].to_s : "0.0"
    output
  end

  #map from Connec! to Base
  map from('name'), to('name')
  map from('reference'), to('sku')
  map from('description'), to('description'), default: "This item has no description"

  map from('status') {|value| value == true ? "ACTIVE" : "INACTIVE"}, to('active') {|value| :active.to_s.upcase ? true : false}

  map from('sale_price/total_amount') {|value| BigDecimal.new(value).to_f}, to("prices[0]/amount", &:to_s), default: 0
  map from('sale_price/currency'), to("prices[0]/currency")

  map from('purchase_price/total_amount') {|value| BigDecimal.new(value).to_f}, to('cost', &:to_s)
  map from('purchase_price/currency'), to('cost_currency')
end
