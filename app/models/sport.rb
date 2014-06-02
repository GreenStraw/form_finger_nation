class Sport < ActiveRecord::Base
  has_many :teams
  has_many :favorites, as: :favoritable
  has_many :users, through: :favorites, source: :favoriter, source_type: "User"
end
