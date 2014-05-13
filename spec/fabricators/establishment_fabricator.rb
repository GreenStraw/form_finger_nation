Fabricator(:establishment) do
  name "test_bar"
  image_url nil
  user { Fabricate(:user) }
  address { Fabricate(:address) }
end
