Fabricator(:party) do
  name "test watch party"
  description 'The first one!'
  scheduled_for (Time.now + 2.days)
  organizer { Fabricate(:user) }
  establishment { Fabricate(:establishment) }
  team { Fabricate(:team) }
  sport { Fabricate(:sport) }
  attendees(count: 2) { |attrs, i| Fabricate(:user, name: 'attendee #{i}') }
end
