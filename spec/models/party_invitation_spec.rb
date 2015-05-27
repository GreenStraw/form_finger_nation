require 'spec_helper'

describe PartyInvitation do
  describe "send_invitation" do
    it "sends an email" do
      party_invitation = Fabricate(:party_invitation)
      expect { party_invitation.send_invitation }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe "self.create_invitations(emails, inviter_id, party_id)" do
    it "should create one invitation when one already exists" do
      @emails = ['test1@test.com','test2@test.com']
      existing_invitation = Fabricate(:party_invitation, email: 'test1@test.com')
      PartyInvitation.should_receive(:where).and_return([existing_invitation])
      new_invitation = PartyInvitation.create(user_id: nil, email: 'test2@test.com', inviter_id: '10', party_id: '11')
      PartyInvitation.should_receive(:create).with(user_id: nil, email: 'test2@test.com', inviter_id: '10', party_id: '11').and_return(new_invitation)
      PartyInvitation.should_not_receive(:create).with(user_id: '1', email: 'test1@test.com', inviter_id: '10', party_id: '11')
      new_invitation.should_receive(:send_invitation)
      PartyInvitation.send_invitations(@emails, '10', '11')
    end
  end

  describe "invitees(emails)" do
    it 'creates one with id and one without' do
      user = Fabricate(:user, email: 'test1@test.com', id: '1')
      User.should_receive(:where).and_return([user])
      PartyInvitation.send(:invitees_from, ['test1@test.com','test2@test.com']).should eq([[1, 'test1@test.com'],[nil, 'test2@test.com']])
    end

    it 'creates two without ids' do
      User.should_receive(:where).and_return([])
      PartyInvitation.send(:invitees_from, ['test1@test.com','test2@test.com']).should eq([[nil, 'test1@test.com'],[nil, 'test2@test.com']])
    end
  end
end

# == Schema Information
#
# Table name: party_invitations
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  uuid       :string(255)
#  status     :string(255)      default("pending")
#  inviter_id :integer
#  user_id    :integer
#  party_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
