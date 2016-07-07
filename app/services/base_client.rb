require 'restclient'

class BaseClient

  def initialize(organization = "default")
    @organization = organization
  end

  RED_URI = "https://84563b04.ngrok.io/auth/baseCRM/callback"

  #Requests oauth2 code
  def self.authorize(auth_params)
    OAuth2::Client.new(ENV['client_id'],
                       ENV['client_secret'],
                       site: "https://api.getbase.com",
                       authorize_url: "/oauth2/authorize?#{auth_params}"
                      )
  end
  #Obtains oauth2 token
  def self.obtain_token
    OAuth2::Client.new(ENV['client_id'],
                       ENV['client_secret'],
                       site: "https://api.getbase.com",
                       token_url: "/oauth2/token"
                      )
  end
  #Fetches all the resources for the specific entity
  def get_entities(entity_name = "")
    headers = {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }
  response = RestClient::Request.execute method: :get, url: "https://api.getbase.com/v2/#{entity_name.downcase.pluralize}", headers: headers
  items = JSON.parse(response)['items']
  end
  #creates an entity with the parameters passed
  def create_entities(mapped_connec_entity, external_entity_name)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }

    body = mapped_connec_entity

    response = RestClient::Request.execute method: :post, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}",
                                                   payload: body, headers: headers
  end
  #updates an existing entity with the parameters providedß
  def update_entities(mapped_connec_entity, external_id, external_entity_name)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }

    body = mapped_connec_entity

    response = RestClient::Request.execute method: :put, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}/#{external_id}",
                                                   payload: body, headers: headers
  end

  private
  attr_reader :organization
end
