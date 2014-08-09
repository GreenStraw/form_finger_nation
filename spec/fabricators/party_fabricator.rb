Fabricator(:party) do
  name "test watch party"
  description "The first one!"
  is_private false
  scheduled_for DateTime.now+2.days
  organizer { Fabricate(:user) }
  venue { Fabricate(:venue) }
  team { Fabricate(:team) }
  sport { Fabricate(:sport) }
  address { Fabricate(:address) }
  party_reservations(count: 2) { |attrs, i| Fabricate(:party_reservation) }
end

# == Schema Information
#
# Table name: parties
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_private    :boolean          default(FALSE)
#  verified      :boolean          default(FALSE)
#  description   :string(255)
#  scheduled_for :datetime
#  organizer_id  :integer
#  team_id       :integer
#  sport_id      :integer
#  venue_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#
