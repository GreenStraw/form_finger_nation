class Package < ActiveRecord::Base
  validates :name, presence: true

  has_many :party_packages
  has_many :parties, through: :party_packages
  has_many :vouchers
  belongs_to :venue
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
