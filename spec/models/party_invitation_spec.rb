require 'spec_helper'

describe PartyInvitation do
  it "sends an email" do
    party_invitation = Fabricate(:party_invitation)
    expect { party_invitation.send_invitation }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
  describe "self.create_invitations(invitees, inviter_id, party_id)" do
    it "should create one invitation when one already exists" do
      @invitees = [[1, 'test1@test.com'], [nil, 'test2@test.com']]
      existing_invitation = Fabricate(:party_invitation, email: 'test1@test.com')
      existing_invitation.stub(:id).and_return('1')
      PartyInvitation.should_receive(:create).with(user_id: nil, email: 'test2@test.com', inviter_id: '10', party_id: '11')
      PartyInvitation.should_not_receive(:create).with(user_id: '1', email: 'test1@test.com', inviter_id: '10', party_id: '11')
      PartyInvitation.create_invitations(@invitees, '10', '11')
    end

    it "should create both invitations when none already exist" do
      @invitees = [[1, 'test1@test.com'], [nil, 'test2@test.com']]
      PartyInvitation.should_receive(:create).with(user_id: nil, email: 'test2@test.com', inviter_id: '10', party_id: '11')
      PartyInvitation.should_not_receive(:create).with(user_id: '1', email: 'test1@test.com', inviter_id: '10', party_id: '11')
      PartyInvitation.create_invitations(@invitees, '10', '11')
    end
  end
end
