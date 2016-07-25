require 'restclient'

class BaseAPIManager

  def initialize(organization = "default")
    @organization = organization
  end

  #Fetches all the resources for the specific entity
  def get_entities(entity_name="", opts={}, last_synchronization_date=nil)
    begin
      batched_call = opts[:__skip] && opts[:__limit]

      query = QueryParamsManager.batched_call(opts) if batched_call
      query = QueryParamsManager.by_updated_at if last_synchronization_date

      response = RestClient.get "https://api.getbase.com/v2/#{entity_name.downcase.pluralize}?#{query}", headers_get
      #the meta field is retrieved indipendently to avoid conflicting with DataParser
      meta = JSON.parse(response)['meta']
      #DataParser strips the response from 'items' and 'data' fields
      entities = DataParser.from_base_collection(response.body)

      unless batched_call
        while meta['links']['next_page']
          response = RestClient.get "#{meta['links']['next_page']}", headers_get
          entities.concat DataParser.from_base_collection(response.body)
          raise 'No response received while fetching subsequent page' unless response && !response.body.blank?
          break if last_synchronization_date && Time.parse(entities.last['updated_at']) < last_synchronization_date
        end
      end
      entities
    rescue => e
      Rails.logger.warn "Error while fetching #{entity_name}. Error: #{e}"
      raise "Error while fetching #{entity_name}. Error: #{e}"
    end
  end

  #creates an entity with the parameters passed
  def create_entities(mapped_connec_entity, external_entity_name)
    #DataParser adds the 'data' field before pushing to BaseCRM
    body = DataParser.to_base(mapped_connec_entity)
    payload = JSON.generate(body)
    begin
      response = RestClient::Request.execute method: :post, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}",
                                             payload: payload, headers: headers_post_put
      DataParser.from_base_single(response.body)
    rescue => e
      standard_rescue(e)
    end
  end

  #updates an existing entity with the parameters provided
  def update_entities(mapped_connec_entity, external_id, external_entity_name)
    body = DataParser.to_base(mapped_connec_entity)
    payload = JSON.generate(body)
    begin
      response = RestClient::Request.execute method: :put, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}/#{external_id}",
                                             payload: payload, headers: headers_post_put
      DataParser.from_base_single(response)
    rescue => e
      if e.class == RestClient::ResourceNotFound
        raise Exceptions::RecordNotFound.new("The record has been deleted in BaseCRM")
      else
        standard_rescue(e)
      end
    end
  end

  private
  attr_reader :organization

  def headers_get
    {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }
  end

  def headers_post_put
      headers_get.merge!("Content-Type" => "application/json")
  end

  def standard_rescue(e)
    err = e.respond_to?(:response) ? e.response : e
    Rails.logger.warn "Error while posting to #{external_entity_name}: #{err}"
    raise "Error while sending data: #{err}"
  end
end
