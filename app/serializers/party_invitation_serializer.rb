class PartyInvitationSerializer < ActiveModel::Serializer
  attributes :id, :email, :registered, :uuid, :status
  has_one :party, key: :party_id, root: :party_id
  has_one :user, key: :user_id, root: :user_id
  has_one :inviter, key: :inviter_id, root: :inviter_id

  def registered
    user.present?
  end

end
