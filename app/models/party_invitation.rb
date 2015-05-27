class PartyInvitation < ActiveRecord::Base
  before_validation :create_uuid, on: :create
  validates_presence_of :uuid, :email
  validates_uniqueness_of :uuid

  belongs_to :inviter, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :user
  belongs_to :party

  PENDING = 'pending'
  ACCEPTED = 'accepted'

  def send_invitation
    PartyInvitationMailer.invitation_email(self).deliver
  end

  def self.send_invitations(emails, inviter_id, party_id)
    invitations = []
    #remove emails that already have an invitation for this party
    existing_invitation_emails = PartyInvitation.where(email: emails, party_id: party_id).map(&:email)
    emails = emails.reject{|e| existing_invitation_emails.include?(e)}

    invitees = invitees_from(emails)
    invitees.each do |invitee|
      invitation = PartyInvitation.create(user_id: invitee[0],
                                          email: invitee[1],
                                          inviter_id: inviter_id,
                                          party_id: party_id)
      invitation.send_invitation
    end
  end

  private

  def self.invitees_from(emails)
    invitees = User.where(email: emails).map{|u| [u.id, u.email]}
    invitee_emails = invitees.map{|i| i[1]}
    emails = emails.reject{|e| invitee_emails.include?(e)}
    emails.each do |email|
      invitees << [nil,email]
    end
    invitees
  end

  def create_uuid
    self.uuid = SecureRandom.hex(20)
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
