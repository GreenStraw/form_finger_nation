Fabricator(:user) do
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
  password 'foobarbaz'
  sports []
  teams []
  establishments []
end
