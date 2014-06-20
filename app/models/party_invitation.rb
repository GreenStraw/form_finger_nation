class PartyInvitation < ActiveRecord::Base
  before_validation :create_uuid, on: :create
  validates_presence_of :uuid
  validates_uniqueness_of :uuid

  belongs_to :inviter, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :user
  belongs_to :party

  def send_invitation
    PartyInvitationMailer.invitation_email(self).deliver
  end

  def self.create_invitations(invitees, inviter_id, party_id)
    invitations = []
    invitees.each do |invitee|
      if PartyInvitation.where(email: invitee[1], party_id: party_id).empty?
        invitations << PartyInvitation.create(user_id: invitee[0],
                                              email: invitee[1],
                                              inviter_id: inviter_id,
                                              party_id: party_id)
      end
    end
    invitations
  end

  private

  def create_uuid
    self.uuid = SecureRandom.hex(20)
  end
end
