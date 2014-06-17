Fabricator(:tenant) do
  name 'Example Company, Inc.'
  api_token 'SPEAKFRIENDANDENTER'
end

Fabricator(:test_tenant, from: :tenant) do
  name 'Test Company, Inc.'
  api_token 'SPEAKFRIENDANDENTER'
end
