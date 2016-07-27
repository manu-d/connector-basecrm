class Entities::SubEntities::PersonMapper
  extend HashMapper

  # after_denormalize do |input, output|
  #   output[:assignee_type] = "AppUser"
  # end


  map from('job_title'), to('title')
  map from('first_name'), to('first_name')
  map from('last_name'), to('last_name')
  map from('email/address'), to('email')

  map from('organization_id'), to('contact_id')
  #map from('assignee_id'), to('owner_id')

  map from('contact_channel/skype'), to('skype')
  map from('phone_work/landline'), to('phone')
  map from('phone_work/mobile'), to('mobile')
  map from('phone_work/fax'), to('fax')

  map from('address_work/billing/line1'), to('address/line1')
  map from('address_work/billing/city'), to('address/city')
  map from('address_work/billing/postal_code'), to('address/postal_code')
  map from('address_work/billing/country'), to('address/country')
end
