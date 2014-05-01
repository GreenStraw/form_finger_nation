require 'spec_helper'

describe Api::V1::OmniauthCallbacksController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:api_v1_user]
    OmniAuth.config.test_mode = true
    @url_regex = /\/callback\?auth_token=(.*)&remember=true/
  end

  describe 'POST facebook_oauth2' do
    context 'auth success' do
      before do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({:provider => 'facebook',
                                                     :uid => '123545',
                                                     :info => {
                                                       :name => 'facebook user',
                                                       :email => 'test_user@gmail.com'
                                                      }
                                                     })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        post :facebook
      end
      it 'redirects' do
        response.response_code.should == 302
      end
      it 'redirects to callback path' do
        path = response.header['Location'].scan(/callback?/)[0]
        path.should == 'callback'
      end
      it 'returns auth token' do
        auth_token = response.header['Location'].scan(@url_regex)
        auth_token.should_not be_empty
      end
    end
    context 'auth failure' do
      before do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        post :facebook
      end
      it 'redirects to err_500' do
        path = URI.parse(response.header['Location']).path.scan(/\/(err_500)/)[0][0]
        path.should == 'err_500'
      end
    end
  end
end
