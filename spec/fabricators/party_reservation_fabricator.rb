Fabricator(:party_reservation) do
  user { Fabricate(:user) }
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
end

Fabricator(:full_party_reservation, from: :party_reservation) do
  party { Fabricate(:party) }
  user { Fabricate(:user) }
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
end

# == Schema Information
#
# Table name: party_reservations
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  user_id    :integer
#  party_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
