Fabricator(:tenant) do
  name 'Example Company, Inc.'
  api_token 'SPEAKFRIENDANDENTER'
end

Fabricator(:test_tenant, from: :tenant) do
  name 'Test Company, Inc.'
  api_token 'SPEAKFRIENDANDENTER'
end

# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(255)
#  api_token  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
