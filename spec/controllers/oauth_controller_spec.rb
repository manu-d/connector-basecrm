require 'spec_helper'

describe OauthController, :type => :controller do
  describe 'request_omniauth' do
    let(:organization) { create(:organization, uid: 'uid-123') }
    before {
      allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_organization).and_return(organization)
    }
    subject { get :request_omniauth, provider: 'basecrm' }

    context 'when not admin' do
      before {
        allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin).and_return(false)
      }

      it {expect(subject).to redirect_to(root_url)}
    end

    context 'when admin' do
      before {
        allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin).and_return(true)
      }

      it "Redirects to Base authorize endpoint" do
        expect(subject.redirect_url).to match(/https:\/\/api.getbase.com\/oauth2\/authorize.+?state=uid-123$/)
      end
    end
  end

  describe 'create_omniauth' do
    let(:user) { Maestrano::Connector::Rails::User.new(email: 'test@email.com', tenant: 'default') }
    let(:org_manager) { double(OrganizationManager)}
    before {
      allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_user).and_return(user)
    }
    let(:uid) { 'uid-123' }
    subject { get :create_omniauth, provider: 'basecrm', state: uid, code: "test123" }
    let(:callback) { post :create_omniauth, provider: 'basecrm', state: uid, code: "test123"}

    context 'when no organization exists' do
      it 'does nothing' do
        expect(Maestrano::Connector::Rails::External).to_not receive(:fetch_user)
      end
    end

    context 'when organization does not exist for this tenant' do
      let(:organization) { create(:organization, tenant: 'lala', uid: uid) }

      it 'does nothing' do
        expect(Maestrano::Connector::Rails::External).to_not receive(:fetch_user)
      end
    end

    context 'when organization is found' do
      let!(:organization) { create(:organization, tenant: 'default', uid: uid) }

      context 'when not admin' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(false)
        }

        it 'does nothing' do
          expect(Maestrano::Connector::Rails::External).to_not receive(:fetch_user)
          subject
        end
      end

      context 'when admin' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(true)
          allow_any_instance_of(OAuth2::Strategy::AuthCode).to receive(:get_token) { "Test"}
          allow(OrganizationManager).to receive(:update) { "Test"}
        }

        it 'updates the organization with data from oauth and api calls' do
          callback
          expect(OrganizationManager.update).to eq "Test"
        end
      end
    end
  end

  describe 'destroy_omniauth' do
    let(:organization) { create(:organization, oauth_uid: 'oauth_uid') }
    subject {get :destroy_omniauth, organization_id: id}

    context 'when no organization is found' do
      let(:id) { 5 }

      it {expect{ subject }.to_not change{ organization.oauth_uid }}
    end

    context 'when organization is found' do
      let(:id) { organization.id }
      let(:user) { Maestrano::Connector::Rails::User.new(email: 'test@email.com', tenant: 'default') }
      before {
        allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_user).and_return(user)
      }

      context 'when not admin' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(false)
        }

        it {expect{ subject }.to_not change{ organization.oauth_uid }}
      end

      context 'when admin' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(true)
        }

        it {
          subject
          organization.reload
          expect(organization.oauth_uid).to be_nil
        }
      end
    end
  end
end
