class Establishment < ActiveRecord::Base
  has_one :address, as: :addressable
  accepts_nested_attributes_for :address
  has_many :parties
  belongs_to :user
end
