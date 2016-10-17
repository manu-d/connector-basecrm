class OauthController < ApplicationController

  def request_omniauth
    if is_admin
      auth_params = {
        state: current_organization.uid
      }
      client = AuthClient.authorize(QueryParamsManager.query_params(auth_params))
      redirect_to client.auth_code.authorize_url(redirect_uri: AuthClient::RED_URI )
    else
      redirect_to root_url
    end
  end

  def create_omniauth
    org_uid = params[:state]
    organization = Maestrano::Connector::Rails::Organization.find_by_uid_and_tenant(org_uid, current_user.tenant)
    if organization && is_admin?(current_user, organization)
      client = AuthClient.obtain_token
      if params[:code].present?
        token = client.auth_code.get_token(params[:code], redirect_uri: AuthClient::RED_URI)
        OauthController.update_organization_omniauth(organization, token)
      end
    end
    redirect_to root_url
  end

  def destroy_omniauth
    organization = Maestrano::Connector::Rails::Organization.find_by_id(params[:organization_id])

    if organization && is_admin?(current_user, organization)
      organization.clear_omniauth
    end

    redirect_to root_url
  end

  private

  def self.update_organization_omniauth(organization, token)
    organization.oauth_uid = "baseCRM-001"
    organization.oauth_token = token.token
    organization.refresh_token = token.refresh_token
    organization.oauth_provider = 'Base'
    organization.save
    company = Maestrano::Connector::Rails::External.fetch_company(organization)
    organization.update(oauth_uid: company['id'])
    organization.save
  end

end
