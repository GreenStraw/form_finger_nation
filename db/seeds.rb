User.create([
  { email: 'test@test.com', password: '123123123', name: 'test' },
  { email: 'bar@example.com', password: 'barpassword', name: 'bar' }
])

Sport.create([
  { name: 'NFL' },
  { name: 'MLB' }
])

UserSportSubscription.create([
  { user_id: 1, sport_id: 1}
])

Team.create([
  { name: 'FC Dallas', sport_id: 5, admin_id: 1},
  { name: 'Houston Dynamo', sport_id: 5},
  { name: 'Dallas Cowboys', sport_id: 1}
])

UserTeamSubscription.create([
  { user_id: 4, team_id: 1 }
])

Venue.create([
  { name: 'Bar 1', description: 'We show sports!', street1: '8021 Davis Mountain Pass', city: 'Austin', state: 'TX', zip: '78726'},
  { name: 'Bar 2', description: 'We show sports!', street1: '14504 Gold Fish Pond Ave', city: 'Austin', state: 'TX', zip: '78728'},
  { name: 'Bar 3', description: 'We show sports!', street1: '3705 Elmcrest Circle', city: 'Garland', state: 'TX', zip: '79424'}
])

VenueSportSubscription.create([
  { venue_id: 1, sport_id: 1 },
  { venue_id: 2, sport_id: 1 }
])

VenueTeamSubscription.create([
  { venue_id: 1, team_id: 1 },
  { venue_id: 2, team_id: 1 }
])
