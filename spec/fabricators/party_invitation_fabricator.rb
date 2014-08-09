Fabricator(:party_invitation) do
  party { Fabricate(:party) }
  inviter { Fabricate(:user) }
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
end

Fabricator(:member_party_invitation, from: :party_invitation) do
  user { Fabricate(:user) }
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
