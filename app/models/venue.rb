class Venue < ActiveRecord::Base
  resourcify
  validates_presence_of :name
  after_create :ensure_address

  has_many :comments, as: :commenter
  has_many :parties, dependent: :destroy
  has_many :favorites, as: :favoriter, dependent: :destroy
  has_many :followed_sports, through: :favorites, source: :favoritable, source_type: "Sport"
  has_many :followed_teams, through: :favorites, source: :favoritable, source_type: "Team"
  has_many :packages
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address
  mount_uploader :image_url, ImageUploader

  # after_create :attach_role

  def self.addressExist?(longitude, latitude, street2)
      address = Address.where(addressable_type: 'Venue', longitude: longitude, latitude: latitude, street2: street2)
      if (address.present?)
        return true
      else
        return false
      end
  end

  def upcoming_parties
    #self.parties.where('scheduled_for >= ?', Time.current).order(:scheduled_for)
    self.parties.where('scheduled_for >= ?', DateTime.now).where("is_cancelled =? AND verified =?", false, true).order(:scheduled_for)
  end

  def past_parties
    self.parties.where('scheduled_for < ?', DateTime.now).where(:verified =>  true).order(:scheduled_for)
  end

  def name_and_address
    "#{self.name} (#{self.address.street1} #{self.address.city}, #{self.address.state})"
  end

  def managers
    User.with_role(:venue_manager, self) || []
  end

  private

  def attach_role
    current_user.add_role(:venue_manager, self) unless current_user.has_role?(:venue_manager, self)
  end

  def ensure_address
    if address.nil?
      create_address
    end
  end
end

# == Schema Information
#
# Table name: venues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  image_url       :string(255)
#  isAtVenue       :boolean
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
