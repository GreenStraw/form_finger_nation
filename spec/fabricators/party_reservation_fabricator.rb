Fabricator(:party_reservation) do
  party { Fabricate(:party) }
  user { Fabricate(:user) }
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
end
