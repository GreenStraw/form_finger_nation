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
  { name: 'Pluckers', description: 'Sports bar & grill offering wings, burgers & more, plus trivia & bingo nights.', address: Address.create(street1: '11066 Pecan Park Blvd', city: 'Cedar Park', state: 'TX', zip: '78613')},
  { name: 'Third Base', description: 'Loud, lively bars with lots of TVs, happy-hour deals & pub grub, including several kinds of wings.', address: Address.create(street1: '3107 S Interstate 35', city: 'Round Rock', state: 'TX', zip: '78664')},
  { name: 'Scholz Garten', description: 'Packed during football games, this famed spot features beer & burgers in a shaded outdoor setting.', address: Address.create(street1: '1607 San Jacinto Blvd', city: 'Austin', state: 'TX', zip: '78701')},
  { name: 'Bikinis Sports Bar & Grill', description: '', address: Address.create(street1: '6901 N I H 35', city: 'Austin', state: 'TX', zip: '78752')}
])

Party.create([
  { name: 'Cowboys watch party', description: 'Go Cowboys!', is_private: false, verified: false, scheduled_for: DateTime.now + 10.days, organizer_id: 1, team_id: Team.find_by_name('Dallas Cowboys').id, venue_id: Venue.find_by_name('Pluckers').id },
  { name: 'FC Dallas MLS watch party', description: '', is_private: false, verified: false, scheduled_for: DateTime.now - 1.day, organizer_id: 1, team_id: Team.find_by_name('FC Dallas').id, venue_id: Venue.find_by_name('Third Base').id },
  { name: 'Houston Dynamo MLS watch party', description: '', is_private: false, verified: false, scheduled_for: DateTime.now - 1.day, organizer_id: 1, team_id: Team.find_by_name('Houston Dynamo').id, venue_id: Venue.find_by_name('Scholz Garten').id },
  { name: 'Real Salt Lake MLS watch party', description: 'Utah takeover!', is_private: false, verified: false, scheduled_for: DateTime.now - 1.day, organizer_id: 1, team_id: Team.find_by_name('Real Salt Lake').id, venue_id: Venue.find_by_name('Bikinis Sports Bar & Grill').id }
])

Package.create([
  { name: "Wings for five cents", description: "Wings for $0.05", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Pluckers').id },
  { name: "Beer for some amount of money", description: "BEER!", price: "4.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Pluckers').id },
  { name: "Ten cent wings", description: "Wings for $0.10", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Third Base').id },
  { name: "Bucket of beer $8", description: "It's a bucket of beer", price: "8.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Third Base').id },
  { name: "Sliders 4/$3", description: "Sliders", price: "3.0", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Scholz Garten').id },
  { name: "Domestic longnecks $1.50 all night", description: "1.50 domestic longnecks", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Scholz Garten').id },
  { name: "Shrimp cocktail", description: "yeah, shrimp cocktail", price: "2.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Bikinis Sports Bar & Grill').id },
  { name: "Pint draft $2.00 all night", description: "Any draft beer $2.00 all night with voucher", price: "5.00", is_public: false, party_ids: [], voucher_ids: [], venue_id: Venue.find_by_name('Bikinis Sports Bar & Grill').id },

])

u = User.find_by_email('admin@test.com')
u.add_role(:admin)

u = User.find_by_email('team_admin@test.com')
u.add_role(:team_admin, Team.find_by_name('FC Dallas'))

u = User.find_by_email('venue_manager@test.com')
u.add_role(:manager, Venue.find_by_name('Pluckers'))
u.add_role(:manager, Venue.find_by_name('Third Base'))
u.add_role(:manager, Venue.find_by_name('Scholz Garten'))
u.add_role(:manager, Venue.find_by_name('Bikinis Sports Bar & Grill'))
