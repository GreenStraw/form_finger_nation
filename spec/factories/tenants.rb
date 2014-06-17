# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :tenant do
    name 'Example Company, Inc.'
  end

  factory :test_tenant, class: Tenant  do
    name 'Test Company, Inc.'
  end

end

# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
