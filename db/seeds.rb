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
