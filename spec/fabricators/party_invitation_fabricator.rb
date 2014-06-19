Fabricator(:party_invitation) do
  party { Fabricate(:party) }
  inviter { Fabricate(:user) }
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
end

Fabricator(:member_party_invitation, from: :party_invitation) do
  user { Fabricate(:user) }
end
