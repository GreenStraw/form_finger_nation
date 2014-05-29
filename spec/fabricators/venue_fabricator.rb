Fabricator(:venue) do
  name "test_bar"
  image_url nil
  description "it's an established venue"
  address {Fabricate(:address)}
  user { Fabricate(:user) }
end
