require 'spec_helper'

def api_get_call_contacts
  "{\"items\":[{\"data\":{\"id\":135906739,\"creator_id\":960788,
    \"contact_id\":null,\"created_at\":\"2016-07-19T10:20:07Z\",
    \"updated_at\":\"2016-07-19T10:20:08Z\",\"title\":null,
    \"name\":\"Base CRM\",\"first_name\":null,\"last_name\":null,
    \"description\":null,\"industry\":null,\"website\":null,
    \"email\":null,\"phone\":null,\"mobile\":null,\"fax\":null,
    \"twitter\":null,\"facebook\":null,\"linkedin\":null,\"skype\":null,
    \"owner_id\":960788,\"is_organization\":true,
    \"address\":{\"city\":\"Chicago\",\"line1\":\"Suite 200 212 W. Superior\",
    \"postal_code\":null,\"state\":\"IL\",\"country\":\"United States\"},
    \"tags\":[],\"custom_fields\":{},\"customer_status\":\"none\",
    \"prospect_status\":\"current\"},\"meta\":{\"version\":2,\"type\":\"contact\"}},
    {\"data\":{\"id\":135906741,\"creator_id\":960788,\"contact_id\":135906739,
      \"created_at\":\"2016-07-19T10:20:07Z\",\"updated_at\":\"2016-07-19T10:20:08Z\",
      \"title\":null,\"name\":\"Support Team\",\"first_name\":\"Support\",\"last_name\":\"Team\",
      \"description\":null,\"industry\":null,\"website\":null,\"email\":null,
      \"phone\":\"+1 (800) 940-9650\",\"mobile\":null,\"fax\":null,\"twitter\":null,
      \"facebook\":null,\"linkedin\":null,\"skype\":null,\"owner_id\":960788,
      \"is_organization\":false,\"address\":{\"city\":\"Chicago\",
      \"line1\":\"Suite 200 212 W. Superior\",\"postal_code\":null,
      \"state\":\"IL\",\"country\":\"United States\"},\"tags\":[],
      \"custom_fields\":{},\"customer_status\":\"none\",\"prospect_status\":\"current\"},
      \"meta\":{\"version\":2,\"type\":\"contact\"}}],\"meta\":{\"type\":\"collection\",\"count\":2,
      \"links\":{\"self\":\"https://api.getbase.com/v2/contacts?page=1&per_page=25\"}}}"
end

def api_response_from_post
  '{"meta":{"type":"product"},"data":{"id":470988,"updated_at":"2016-07-20T15:34:24Z",
  "created_at":"2016-07-20T15:34:24Z","active":true,"description":"Includes more storage options",
  "name":"Enterprise NEW Plan","sku":"enterprise-plan","prices":[{"currency":"PLN","amount":"2599.99"},
  {"currency":"USD","amount":"2599.99"}],"max_discount":15,"max_markup":null,"cost":"1599.99","cost_currency":"USD"}}'
end

def mapped_connec_entity
  { "id" =>  12345678, "first_name" => "John", "last_name" => "Smith"}
end
