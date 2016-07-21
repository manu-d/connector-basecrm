class Entities::SubEntities::PersonMapper
  extend HashMapper

  map from('title'), to('title')
  map from('first_name'), to('first_name')
  map from('last_name'), to('last_name')
  map from('email/address'), to('email')

  map from('address_work/billing/line1'), to('address/line1')
  map from('address_work/billing/city'), to('address/city')
  map from('address_work/billing/postal_code'), to('address/postal_code')
  map from('address_work/billing/country'), to('address/country')
end
