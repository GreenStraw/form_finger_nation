class Venue < ActiveRecord::Base
  has_many :comments, as: :commenter
  has_many :parties
  has_one :address, as: :addressable, dependent: :destroy
  belongs_to :user
end
