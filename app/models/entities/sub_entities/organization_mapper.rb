class Entities::SubEntities::OrganizationMapper
  extend HashMapper

  map from('name'), to('name')
  map from('industry'), to('industry')
  map from('email/address'), to('email')

  map from('address_work/billing/line1'), to('address/line1')
  map from('address_work/billing/city'), to('address/city')
  map from('address_work/billing/postal_code'), to('address/postal_code')
  map from('address_work/billing/region'), to('address/state')
  map from('address_work/billing/country'), to('address/country')

  map from('website/url'), to('website')
end
