User.all.map(&:destroy)
Sport.all.map(&:destroy)
Team.all.map(&:destroy)
Venue.all.map(&:destroy)

User.create([
  { email: 'admin@test.com', password: '123123123', username: 'ndanger', first_name: 'Nick', last_name: 'Danger', address: Address.create(city: 'Dallas', state: 'TX', zip: '75040') },
  { email: 'team_admin@test.com', password: '123123123', username: 'putdownthatpickle', first_name: 'Rocky', last_name: 'Rococo', address: Address.create(city: 'Oklahoma City', state: 'OK', zip: '73105')},
  { email: 'venue_manager@test.com', password: '123123123', username: 'rspoilsport', first_name: 'Ralph', last_name: 'Spoilsport', address: Address.create(city: 'Austin', state: 'TX', zip: '78726')},
  { email: 'user@test.com', password: '123123123', username: 'jbeets', first_name: 'Joe', last_name: 'Beets', address: Address.create(city: 'Austin', state: 'TX', zip: '78728')}
])

User.all.each do |user|
  user.confirm!
end

Sport.create([
  { name: 'NFL' },
  { name: 'MLB' },
  { name: 'MLS' }
])

Team.create([
  { name: 'FC Dallas', sport: Sport.find_by_name('MLS')},
  { name: 'Houston Dynamo', sport: Sport.find_by_name('MLS')},
  { name: 'Dallas Cowboys', sport: Sport.find_by_name('NFL')}
])

Venue.create([
  { name: 'Venue 1', description: 'We show sports!', address: Address.create(street1: '8021 Davis Mountain Pass', city: 'Austin', state: 'TX', zip: '78726')},
  { name: 'Venue 2', description: 'Sport sports sports', address: Address.create(street1: '14504 Gold Fish Pond Ave', city: 'Austin', state: 'TX', zip: '78728')},
  { name: 'Venue 3', description: 'Something else here!', address: Address.create(street1: '3705 Elmcrest Circle', city: 'Garland', state: 'TX', zip: '79424')}
])

u = User.find_by_email('admin@test.com')
u.add_role(:admin)

u = User.find_by_email('team_admin@test.com')
u.add_role(:team_admin, Team.find_by_name('FC Dallas'))

u = User.find_by_email('venue_manager@test.com')
u.add_role(:manager, Venue.find_by_name('Venue 1'))
