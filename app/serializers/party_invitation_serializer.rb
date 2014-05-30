class PartyInvitationSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :unregistered_invitee_email, :registered, :uuid, :claimed
  has_one :party, key: :party, root: :party, include: true
  has_one :user, key: :user, root: :user, include: true
  has_one :inviter

  def registered
    user.present?
  end
end
