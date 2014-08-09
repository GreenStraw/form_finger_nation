Fabricator(:address) do
  street1 { sequence(:street1) { |i| "#{i} some street"} }
  street2 'St. 200'
  city 'Austin'
  state 'TX'
  zip '78728'
  longitude 30.00
  latitude 30.00
  addressable_type "Venue"
  addressable_id 1
end

# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  street1          :string(255)
#  street2          :string(255)
#  city             :string(255)
#  state            :string(255)
#  zip              :string(255)
#  latitude         :float
#  longitude        :float
#  created_at       :datetime
#  updated_at       :datetime
#
