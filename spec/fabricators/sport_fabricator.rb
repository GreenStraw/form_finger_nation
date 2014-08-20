Fabricator(:sport) do
  name "sport_name"
  image_url 'fake_image_url'
end

# == Schema Information
#
# Table name: sports
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image_url  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
