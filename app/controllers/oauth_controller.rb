class OauthController < ApplicationController

  def request_omniauth
    if is_admin
      auth_params = {
        state: current_organization.uid
      }
      auth_params = URI.escape(auth_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
      client = OAuth2::Client.new(ENV['client_id'],
                                  ENV['client_secret'],
                                  site: "https://api.getbase.com",
                                  authorize_url: "/oauth2/authorize?#{auth_params}"
                                 )
      redirect_to client.auth_code.authorize_url(redirect_uri: "https://a438c33b.ngrok.io/auth/baseCRM/callback"), id: current_user.id
    else
      redirect_to root_url
    end
  end

  def create_omniauth
    org_uid = params[:state]
    organization = Maestrano::Connector::Rails::Organization.find_by_uid_and_tenant(org_uid, current_user.tenant)

    if organization && is_admin?(current_user, organization)
      client = OAuth2::Client.new(ENV['client_id'],
                                  ENV['client_secret'],
                                  site: "https://api.getbase.com",
                                  token_url: "/oauth2/token"
                                 )
      if params[:code].present?
        token = client.auth_code.get_token(params[:code], redirect_uri: "https://a438c33b.ngrok.io/auth/baseCRM/callback")
        organization.oauth_uid = "baseCRM-001"
        organization.oauth_token = token.token
        organization.refresh_token = token.refresh_token
        organization.provider = 'Base'
        organization.save
      end
    end
    redirect_to root_url
  end

  def destroy_omniauth
    organization = Maestrano::Connector::Rails::Organization.find_by_id(params[:organization_id])

    if organization && is_admin?(current_user, organization)
      organization.oauth_uid = nil
      organization.oauth_token = nil
      organization.refresh_token = nil
      organization.sync_enabled = false
      organization.oauth_provider = nil
      organization.save
    end

    redirect_to root_url
  end
end
