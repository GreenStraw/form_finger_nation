Fabricator(:party_invitation) do
  party { Fabricate(:party) }
  inviter { Fabricate(:user) }
end

Fabricator(:member_party_invitation, from: :party_invitation) do
  user { Fabricate(:user) }
end

Fabricator(:non_member_party_invitation, from: :party_invitation) do
  unregistered_invitee_email { sequence(:email) { |i| "foo#{i}@example.com"} }
end
