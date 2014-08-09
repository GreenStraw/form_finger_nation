Fabricator(:package) do
  name "test package"
  description "wings for 50 cents"
  image_url nil
  price 5.00
  active true
  start_date DateTime.now-1.days
  end_date DateTime.now+7.days
  venue { Fabricate(:venue) }
end

# == Schema Information
#
# Table name: packages
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  image_url   :string(255)
#  price       :decimal(, )
#  active      :boolean
#  is_public   :boolean          default(FALSE)
#  start_date  :datetime
#  end_date    :datetime
#  venue_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#
