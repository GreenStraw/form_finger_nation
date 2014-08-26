class Image < ActiveRecord::Base
  #Attributes or fileds
  attr_accessible :image

  #associations
  belongs_to :user
  belongs_to :venue
  belongs_to :sport
  belongs_to :team
  belongs_to :package

  #carrier wave
  mount_uploader :image, ImageUploader
end
