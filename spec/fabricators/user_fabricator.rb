Fabricator(:user) do
  tenant_id nil
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
  password 'foobarbaz'
  sports []
  teams []
end
