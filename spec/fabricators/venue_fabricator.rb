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
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  image_url       :string(255)
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  phone           :string(255)
#  email           :string(255)
#  hours_sunday    :string(255)
#  hours_monday    :string(255)
#  hours_tuesday   :string(255)
#  hours_wednesday :string(255)
#  hours_thusday   :string(255)
#  hours_friday    :string(255)
#  hours_saturday  :string(255)
#
