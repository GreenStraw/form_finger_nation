Fabricator(:venue) do
  name "test_bar"
  image_url nil
  description "it's an established venue"
  address {Fabricate(:address)}
end

# == Schema Information
#
# Table name: venues
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  image_url   :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
