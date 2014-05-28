Fabricator(:venue) do
  name "test_bar"
  image_url nil
  description "it's an established venue"
  street1 '123 Some Street'
  street2 'St. 200'
  city 'Anytown'
  state 'TX'
  zip '78978'
  user { Fabricate(:user) }
end
