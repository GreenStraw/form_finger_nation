require 'spec_helper'

describe Api::V1::PartyInvitationsController do
  let(:member_party_invitation) { Fabricate(:member_party_invitation) }
  let(:non_member_party_invitation) { Fabricate(:non_member_party_invitation) }
  let(:user) { Fabricate(:user) }
  before(:each) do
    Address.any_instance.stub(:geocode).and_return([1,1])
    member_party_invitation
    non_member_party_invitation
    user
    user.confirm!
  end

  describe "claim_by_email" do
    it "should create a new party reservation when party does not contain a reservation for email" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([non_member_party_invitation])
      party = non_member_party_invitation.party
      party.stub_chain(:party_reservations, :where, :count).and_return(0)
      reservation = PartyReservation.create(:unregistered_rsvp_email => non_member_party_invitation.unregistered_invitee_email,
                                            :party_id => non_member_party_invitation.party_id)
      PartyReservation.should_receive(:new).with(unregistered_rsvp_email: non_member_party_invitation.unregistered_invitee_email,
                                                 party_id: non_member_party_invitation.party_id).and_return(reservation)
      get :claim_by_email, id: 'test_uuid'
    end

    it "should return 422 when reservation fails to save" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([non_member_party_invitation])
      party = non_member_party_invitation.party
      party.stub_chain(:party_reservations, :where, :count).and_return(0)
      reservation = PartyReservation.create(:unregistered_rsvp_email => non_member_party_invitation.unregistered_invitee_email,
                                            :party_id => non_member_party_invitation.party_id)
      PartyReservation.should_receive(:new).with(unregistered_rsvp_email: non_member_party_invitation.unregistered_invitee_email,
                                                 party_id: non_member_party_invitation.party_id).and_return(reservation)
      reservation.should_receive(:save!).and_return(false)

      get :claim_by_email, id: 'test_uuid'
      response.response_code.should == 422
    end

    it "should return 422 when no invitation is found" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([])
      get :claim_by_email, id: 'test_uuid'
      response.response_code.should == 422
    end

    it "should return 200 when reservation saves" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([non_member_party_invitation])
      party = non_member_party_invitation.party
      party.stub_chain(:party_reservations, :where, :count).and_return(0)
      reservation = PartyReservation.create(:unregistered_rsvp_email => non_member_party_invitation.unregistered_invitee_email,
                                            :party_id => non_member_party_invitation.party_id)
      PartyReservation.should_receive(:new).with(unregistered_rsvp_email: non_member_party_invitation.unregistered_invitee_email,
                                                 party_id: non_member_party_invitation.party_id).and_return(reservation)
      reservation.should_receive(:save!).and_return(true)

      get :claim_by_email, id: 'test_uuid'
      response.response_code.should == 200
    end

    it "should not create a new party reservation when party does contain a reservation for email" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([non_member_party_invitation])
      party = non_member_party_invitation.party
      party.stub_chain(:party_reservations, :where, :count).and_return(1)
      PartyReservation.should_not_receive(:new)
      get :claim_by_email, id: 'test_uuid'
    end
  end

  describe "claim_by_user" do
    it "should add attendee to party and party does not already contain the attendee" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([member_party_invitation])
      user = User.find(member_party_invitation.user_id)
      party = Party.find(member_party_invitation.party_id)
      User.should_receive(:find_by_id).with(member_party_invitation.user_id).and_return(user)
      member_party_invitation.party.attendees.should_receive(:include?).with(user).and_return(false)
      member_party_invitation.party.attendees.map(&:id).should_not include(user.id)
      get :claim_by_user, id: 'test_uuid'
      member_party_invitation.party.attendees.map(&:id).should include(user.id)
    end
    it "should not call save when party does already contain the attendee" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([member_party_invitation])
      user = User.find(member_party_invitation.user_id)
      party = Party.find(member_party_invitation.party_id)
      User.should_receive(:find_by_id).with(member_party_invitation.user_id).and_return(user)
      member_party_invitation.party.attendees.should_receive(:include?).with(user).and_return(true)
      member_party_invitation.party.should_not_receive(:save!)
      get :claim_by_user, id: 'test_uuid'
    end
    it "should return 422 when invitation is not present" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([])
      get :claim_by_user, id: 'test_uuid'
      response.response_code.should == 422
    end
    it "should return 422 when user is not present" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([member_party_invitation])
      User.should_receive(:find_by_id).with(member_party_invitation.user_id).and_return(nil)
      get :claim_by_user, id: 'test_uuid'
      response.response_code.should == 422
    end
    it "should return 422 whensave is not successful" do
      PartyInvitation.should_receive(:where).with(:uuid => 'test_uuid').and_return([member_party_invitation])
      user = User.find(member_party_invitation.user_id)
      party = Party.find(member_party_invitation.party_id)
      User.should_receive(:find_by_id).with(member_party_invitation.user_id).and_return(user)
      member_party_invitation.party.attendees.should_receive(:include?).with(user).and_return(false)
      member_party_invitation.party.should_receive(:save!).and_return(false)
      get :claim_by_user, id: 'test_uuid'
      response.response_code.should == 422
    end
  end

  describe "bulk_create_from_user" do
    it "should not create any invitations if users are not sent" do
      user.ensure_authentication_token!
      request.headers['auth-token'] = user.authentication_token
      request.headers['auth-email'] = user.email
      PartyInvitation.should_not_receive(:new)
      PartyInvitationMailer.should_not_receive(:member_private_watch_party_invitation_email)
      xhr :post, :bulk_create_from_user, :users => [], :inviter => 999, :party_id => 998
    end
    it "should create an invitation for a user passed in" do
      user.ensure_authentication_token!
      request.headers['auth-token'] = user.authentication_token
      request.headers['auth-email'] = user.email
      PartyInvitation.should_receive(:new).with(user_id: user.id.to_s, inviter_id: "999", party_id: "998").and_return(member_party_invitation)
      member_party_invitation.should_receive(:save!).once
      xhr :post, :bulk_create_from_user, :users => [user.id], :inviter => 999, :party_id => 998
    end
    it "should call member_private_watch_party_invitation_email when save completes" do
      user.ensure_authentication_token!
      request.headers['auth-token'] = user.authentication_token
      request.headers['auth-email'] = user.email
      PartyInvitation.should_receive(:new).with(user_id: user.id.to_s, inviter_id: "999", party_id: "998").and_return(member_party_invitation)
      ActionMailer::Base.deliveries = []
      xhr :post, :bulk_create_from_user, :users => [user.id], :inviter => 999, :party_id => 998
      ActionMailer::Base.deliveries.count.should == 1
    end
  end

  describe "bulk_create_from_email" do
    it "should not create any invitations if emails are not sent" do
      user.ensure_authentication_token!
      request.headers['auth-token'] = user.authentication_token
      request.headers['auth-email'] = user.email
      PartyInvitation.should_not_receive(:new)
      PartyInvitationMailer.should_not_receive(:non_member_private_watch_party_invitation_email)
      xhr :post, :bulk_create_from_email, :email_addresses => "", :inviter => 999, :party_id => 998
    end
    it "should create an invitation for a user passed in" do
      user.ensure_authentication_token!
      request.headers['auth-token'] = user.authentication_token
      request.headers['auth-email'] = user.email
      PartyInvitation.should_receive(:new).with(unregistered_invitee_email: 'test@test.com', inviter_id: "999", party_id: "998").and_return(non_member_party_invitation)
      non_member_party_invitation.should_receive(:save!).once
      xhr :post, :bulk_create_from_email, :email_addresses => 'test@test.com', :inviter => 999, :party_id => 998
    end
    it "should call member_private_watch_party_invitation_email when save completes" do
      user.ensure_authentication_token!
      request.headers['auth-token'] = user.authentication_token
      request.headers['auth-email'] = user.email
      PartyInvitation.should_receive(:new).with(unregistered_invitee_email: 'test@test.com', inviter_id: "999", party_id: "998").and_return(non_member_party_invitation)
      ActionMailer::Base.deliveries = []
      xhr :post, :bulk_create_from_email, :email_addresses => 'test@test.com', :inviter => 999, :party_id => 998
      ActionMailer::Base.deliveries.count.should == 1
    end
  end
end

