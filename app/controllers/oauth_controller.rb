class OauthController < ApplicationController

  def request_omniauth
    if is_admin
      auth_params = {state: current_organization.uid}
      client = AuthClient.authorize(QueryParamsManager.query_params(auth_params))
      redirect_to client.auth_code.authorize_url(redirect_uri: redirect_uri)
    else
      redirect_to root_url
    end
  end

  def create_omniauth
    org_uid = params[:state]
    organization = Organization.find_by_uid_and_tenant(org_uid, current_user.tenant)
    if organization && is_admin?(current_user, organization)
      client = AuthClient.obtain_token
      if params[:code].present?
        token = client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
        organization.update_omniauth(token)
      end
    end
    redirect_to root_url
  end

  def destroy_omniauth
    organization = Organization.find_by_id(params[:organization_id])
    organization.revoke_omniauth if organization && is_admin?(current_user, organization)

    redirect_to root_url
  end

  def redirect_uri
    "#{Maestrano[current_organization.tenant].param('app_host')}/auth/baseCRM/callback"
  end
end
