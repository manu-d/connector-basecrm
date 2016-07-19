require 'restclient'

class BaseAPIManager

  def initialize(organization = "default")
    @organization = organization
  end

  #Fetches all the resources for the specific entity
  def get_entities(entity_name = "")
    headers = {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }
  response = RestClient::Request.execute method: :get, url: "https://api.getbase.com/v2/#{entity_name.downcase.pluralize}", headers: headers
  #DataParser strips the response from 'items' and 'data' fields
  DataParser.new.from_base_collection(response)
  end

  #creates an entity with the parameters passed
  def create_entities(mapped_connec_entity, external_entity_name)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }

    #DataParser adds the 'data' field before pushing to BaseCRM
    body = DataParser.new.to_base(mapped_connec_entity)
    payload = JSON.generate(body)
    begin
      response = RestClient::Request.execute method: :post, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}",
                                                     payload: payload, headers: headers
      Rails.logger.debug {"Creating entity #{external_entity_name}, Response: #{response}"}
      DataParser.new.from_base_single(response)
    rescue => e
      err = e.respond_to?(:response) ? e.response : e
      Rails.logger.warn "Error while posting to #{external_entity_name}: #{err}"
      raise "Error while sending data: #{err}"
    end
  end

  #updates an existing entity with the parameters provided
  def update_entities(mapped_connec_entity, external_id, external_entity_name)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }

    body = DataParser.new.to_base(mapped_connec_entity)
    payload = JSON.generate(body)
    begin
      response = RestClient::Request.execute method: :put, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}/#{external_id}",
                                                     payload: payload, headers: headers
      Rails.logger.debug {"Creating entity #{external_entity_name}, Response: #{response}"}
      DataParser.new.from_base_single(response)
    rescue => e
      err = e.respond_to?(:response) ? e.response : e
      Rails.logger.warn "Error while updating #{external_entity_name} with: #{err}"
      raise "Error while sending data: #{err}"
    end
  end
  private
  attr_reader :organization
end
