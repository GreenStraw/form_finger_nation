Fabricator(:team) do
  name "test_team"
  image_url nil
  sport_id '1'
end

# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_url   :string(255)
#  information :text
#  sport_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#
