class Favorite < ActiveRecord::Base
  belongs_to :favoritable, polymorphic: true
  belongs_to :favoriter, polymorphic: true
end

# == Schema Information
#
# Table name: favorites
#
#  id               :integer          not null, primary key
#  favoritable_id   :integer
#  favoritable_type :string(255)
#  favoriter_id     :integer
#  favoriter_type   :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#
