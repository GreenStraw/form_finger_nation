# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first

User.all.map(&:destroy)
Sport.all.map(&:destroy)
Team.all.map(&:destroy)
Venue.all.map(&:destroy)
Party.all.map(&:destroy)
Package.all.map(&:destroy)

t = Tenant.first_or_create({
 :name => 'FoamFingerNation',
 :api_token => 'SPEAKFRIENDANDENTER'
})
Tenant.set_current_tenant(t)

User.create([
  { email: 'admin@test.com', password: '123123123', password_confirmation: '123123123', username: 'ndanger', first_name: 'Nick', last_name: 'Danger', confirmed_at: DateTime.now, address: Address.create(city: 'Dallas', state: 'TX', zip: '75040') },
  { email: 'team_admin@test.com', password: '123123123', password_confirmation: '123123123', username: 'pdtpickle', first_name: 'Rocky', confirmed_at: DateTime.now, last_name: 'Rococo', address: Address.create(city: 'Oklahoma City', state: 'OK', zip: '73105')},
  { email: 'venue_manager@test.com', password: '123123123', password_confirmation: '123123123', username: 'rspoilsport', first_name: 'Ralph', confirmed_at: DateTime.now, last_name: 'Spoilsport', address: Address.create(city: 'Austin', state: 'TX', zip: '78726')},
  { email: 'user@test.com', password: '123123123', password_confirmation: '123123123', username: 'jbeets', first_name: 'Joe', last_name: 'Beets', confirmed_at: DateTime.now, address: Address.create(city: 'Austin', state: 'TX', zip: '78728')}
])

Sport.create([
  { name: 'NFL' },
  { name: 'MLB' },
  { name: 'MLS' }
])

Team.create([
  { name: 'FC Dallas', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Dallas', state: 'TX')},
  { name: 'Houston Dynamo', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Houston', state: 'TX')},
  { name: 'Chicago Fire', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Chicago', state: 'IL')},
  { name: 'Colorado Rapids', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Denver', state: 'CO')},
  { name: 'Real Salt Lake', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Salt Lake City', state: 'UT')},
  { name: 'San Jose Earthquakes', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'San Jose', state: 'CA')},
  { name: 'Portland Timbers', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Portland', state: 'OR')},
  { name: 'Los Angeles Galaxy', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Los Angeles', state: 'CA')},
  { name: 'Columbus Crew', sport: Sport.find_by_name('MLS'), address: Address.create(city: 'Columbus', state: 'OH')},
  { name: 'Dallas Cowboys', sport: Sport.find_by_name('NFL'), address: Address.create(street1: '456 Wow What A Street', city: 'Austin', state: 'TX', zip: '78753')}
])

Venue.create([
  { name: 'Venue 1', description: 'We show sports!', address: Address.create(street1: '8021 Davis Mountain Pass', city: 'Austin', state: 'TX', zip: '78726')},
  { name: 'Venue 2', description: 'Sport sports sports', address: Address.create(street1: '14504 Gold Fish Pond Ave', city: 'Austin', state: 'TX', zip: '78728')},
  { name: 'Venue 3', description: 'Something else here!', address: Address.create(street1: '3705 Elmcrest Circle', city: 'Garland', state: 'TX', zip: '79424')}
])

Party.create([
  { name: 'First Party', description: 'Watching FC Dallas', is_private: false, verified: false, scheduled_for: DateTime.now + 10.days, organizer_id: 1, team_id: Team.find_by_name('FC Dallas').id, venue_id: 1 },
  { name: 'Another Party', description: 'Portland!', is_private: false, verified: false, scheduled_for: DateTime.now - 1.day, organizer_id: 1, team_id: Team.find_by_name('Portland Timbers').id, venue_id: 1 }
])

Package.create([
  { name: "Wings for five cents", description: "Wings for $0.05", price: "5.0", is_public: false, party_ids: [], voucher_ids: [], venue_id: 1 },
  { name: "Beer for some amount of money", description: "BEER!", price: "4.55", is_public: false, party_ids: [], voucher_ids: [], venue_id: 1 }
])

u = User.find_by_email('admin@test.com')
u.add_role(:admin)

u = User.find_by_email('team_admin@test.com')
u.add_role(:team_admin, Team.find_by_name('FC Dallas'))

u = User.find_by_email('venue_manager@test.com')
u.add_role(:manager, Venue.find_by_name('Venue 1'))
