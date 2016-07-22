require 'restclient'

class BaseAPIManager

  def initialize(organization = "default")
    @organization = organization
  end

  #Fetches all the resources for the specific entity
  def get_entities(entity_name = "", opts={})
    begin
      batched_call = opts[:__skip] && opts[:__limit]
      #the page requested is calculated from the offset ([:__skip)]) and (opts[:__limit])
      if batched_call
        page = opts[:__skip] == 0 ? 1 : (opts[:__skip] / opts[:__limit] + 1)
        query = "page=#{page}&per_page=#{opts[:__limit]}"
      end
      response = RestClient.get "https://api.getbase.com/v2/#{entity_name.downcase.pluralize}?#{query}", headers_get
      #the meta field is retrieved indipendently to avoid conflicting with DataParser
      meta = JSON.parse(response)['meta']
      #DataParser strips the response from 'items' and 'data' fields
      entities = DataParser.from_base_collection(response)

      unless batched_call
        while meta['links']['next_page']
          response = Restclient.get "#{meta['links']['next_page']}", headers_get
          raise 'No response received while fetching subsequent page' unless response
          entities << DataParser.from_base_collection(response)
        end
      end
      entities.flatten!
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
      DataParser.from_base_single(response)
    rescue => e
      err = e.respond_to?(:response) ? e.response : e
      Rails.logger.warn "Error while posting to #{external_entity_name}: #{err}"
      raise "Error while sending data: #{err}"
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
        err = e.respond_to?(:response) ? e.response : e
        Rails.logger.warn "Error while updating #{external_entity_name} with: #{err}"
        raise "Entity #{external_entity_name} could not be updated. Error: #{err}"
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
    headers_get.merge("Content-Type" => "application/json")
  end
end
