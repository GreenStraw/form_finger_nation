Fabricator(:user) do
  tenant_id nil
  first_name 'Test'
  last_name 'User'
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
  password 'password'
  password_confirmation 'password'
  sports []
  teams []
end

