Fabricator(:tenant) do
  name 'Example Company, Inc.'
end

Fabricator(:test_tenant, from: :tenant) do
  name 'Test Company, Inc.'
end
