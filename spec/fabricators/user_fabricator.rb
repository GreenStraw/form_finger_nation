Fabricator(:user) do
  tenant_id nil
  confirmed_at DateTime.now
  first_name 'Test'
  last_name 'User'
  username { sequence(:username) { |i| "foo#{i}"} }
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
  password 'password'
  password_confirmation 'password'
  followed_sports []
  followed_teams []
end

