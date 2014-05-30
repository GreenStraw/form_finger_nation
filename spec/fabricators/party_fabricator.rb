Fabricator(:party) do
  name "test watch party"
  description 'The first one!'
  private false
  scheduled_for DateTime.now+2.days
  organizer { Fabricate(:user) }
  venue { Fabricate(:venue) }
  team { Fabricate(:team) }
  sport { Fabricate(:sport) }
  address { Fabricate(:address) }
  attendees(count: 2) { |attrs, i| Fabricate(:user, name: 'attendee #{i}') }
end
