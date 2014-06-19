require 'spec_helper'

describe Api::V1::PartyInvitationsController do
  render_views

  before(:each) do
    create_new_tenant
    @member_party_invitation = Fabricate(:member_party_invitation)
    @party_invitation = Fabricate(:party_invitation)
    request.headers['auth-token'] = @current_user.authentication_token
    request.headers['auth-email'] = @current_user.email
    request.headers['api-token'] = 'SPEAKFRIENDANDENTER'
  end

  describe "PUT accept" do
    before(:each) do
      put :accept, id:@member_party_invitation.id, format: :json
    end

    it "sets status to accepted" do
      assigns(:party_invitation).status.should eq('accepted')
    end
  end
end

