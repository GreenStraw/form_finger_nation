class PartyInvitationSerializer < BaseSerializer
  attributes :email, :registered, :uuid, :status
  has_one :party, embed: :ids
  has_one :user, embed: :ids
  has_one :inviter, embed: :ids

  private

  def registered
    user.present?
  end

end
