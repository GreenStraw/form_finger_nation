Fabricator(:address) do
  street1 { sequence(:street1) { |i| "#{i} some street"} }
  street2 'St. 200'
  city 'Anytown'
  state 'TX'
  zip '78978'
  addressable_type "Venue"
  addressable_id 1
end
