class Party < ActiveRecord::Base
  acts_as_commentable
  validates :name, presence: true
  validates :scheduled_for, presence: true
  validates :venue_id, presence: true

  after_update :send_notification_when_verified
  after_create :ensure_address

  has_many :party_reservations
  has_many :attendees, through: :party_reservations, source: :user
  has_many :party_invitations
  has_many :invitees, through: :party_invitations, source: :user
  has_many :party_packages
  has_many :packages, through: :party_packages
  has_many :vouchers
  has_one :address, as: :addressable, dependent: :destroy
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  belongs_to :team
  belongs_to :sport
  belongs_to :venue

  accepts_nested_attributes_for :address

  attr_accessor :user_ids, :emails

  def scheduled_for=(value)
    if value.is_a?(String)
      value = value.to_i
    end
    self[:scheduled_for] = Time.at(value).to_datetime
  end

  def self.send_host_fourty_eight_hour_notifications
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (DateTime.now+2.days).beginning_of_day, (DateTime.now+2.days).end_of_day)
    parties.each do |party|
      PartyMailer.host_fourty_eight_hour_notification_email(party).deliver
    end
  end

  def self.send_venue_manager_fourty_eight_hour_notifications
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (DateTime.now+2.days).beginning_of_day, (DateTime.now+2.days).end_of_day)
    parties.each do |party|
      PartyMailer.host_fourty_eight_hour_notification_email(party).deliver
    end
  end

  def self.send_attendee_three_day_notifications
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (DateTime.now+3.days).beginning_of_day, (DateTime.now+3.days).end_of_day)
    parties.each do |party|
      party.party_reservations.each do |reservation|
        PartyMailer.attendee_three_day_notification_email(reservation).deliver
      end
    end
  end

  def completed_purchases
    vouchers.where('transaction_id IS NOT NULL')
  end

  def send_notification_when_verified
    if self.verified_changed? && self.verified?
      PartyMailer.watch_party_verified_email(self).deliver
    end
  end

  def unregistered_attendees
    party_reservations.where(:user => nil).map(&:unregistered_rsvp_email)
  end
  
  def self.search(search_item)
    if search_item.blank?
      parties = Party.all
      teams = Team.all
      people = User.all
    else
      search_item = "%" + search_item + "%"
      parties = Party.joins(:organizer, :team, :venue)
        .where(["parties.name ILIKE ? OR parties.description ILIKE ? OR users.email ILIKE ? OR users.username ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ? OR teams.name ILIKE ? OR teams.information ILIKE ? OR venues.name ILIKE ?", 
               search_item, search_item, search_item, search_item, search_item, search_item, search_item, search_item, search_item])               
     teams =  Party.joins(:team)
       .where(["teams.name ILIKE ? or teams.information ILIKE ?", search_item, search_item])
     
      people  =  Party.joins(:organizer)
        .where(["users.email ILIKE ? or users.username ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ?", search_item, search_item, search_item, search_item])    
    end  
   [parties, teams, people]
  end
  
  def self.geo_search(address, radius)
    venue_addresses_in_radius = Address.class_within_radius_of_address('Venue', address, radius)
    venues = venue_addresses_in_radius.map(&:addressable)
    @parties = venues.map(&:parties).flatten.uniq
  end

  private

  def ensure_address
    if address.nil?
      create_address
    end
  end

end

# == Schema Information
#
# Table name: parties
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_private    :boolean          default(FALSE)
#  verified      :boolean          default(FALSE)
#  description   :string(255)
#  scheduled_for :datetime
#  organizer_id  :integer
#  team_id       :integer
#  sport_id      :integer
#  venue_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#
