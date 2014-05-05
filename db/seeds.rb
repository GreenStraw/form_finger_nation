User.create([
  { email: 'foo@example.com', password: 'foopassword', name: 'foo' },
  { email: 'bar@example.com', password: 'barpassword', name: 'bar' }
])

Sport.create([
  { name: 'NFL' },
  { name: 'MLB' }
])

SportSubscription.create([
  { user_id: 1, sport_id: 1}
])

Team.create([
  { name: 'FC Dallas', sport_id: 5},
  { name: 'Houston Dynamo', sport_id: 5},
  { name: 'Dallas Cowboys', sport_id: 1}
])

TeamSubscription.create([
  { user_id: 4, team_id: 1 }
])
