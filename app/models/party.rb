class Party < ActiveRecord::Base
  acts_as_commentable
  validates :name, presence: true
  validates :scheduled_for, presence: true

  after_update :send_notification_when_verified
  after_create :ensure_address

  has_many :party_reservations
  has_many :attendees, through: :party_reservations, source: :user
  has_many :party_invitations
  has_many :invitees, through: :party_invitations, source: :user
  has_many :party_packages
  has_many :packages, through: :party_packages
  has_one :address, as: :addressable, dependent: :destroy
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  belongs_to :team
  belongs_to :sport
  belongs_to :venue

  accepts_nested_attributes_for :address

  attr_accessor :user_ids, :emails

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

  def send_notification_when_verified
    if self.verified_changed? && self.verified?
      PartyMailer.watch_party_verified_email(self).deliver
    end
  end

  def unregistered_attendees
    party_reservations.where(:user => nil).map(&:unregistered_rsvp_email)
  end

  private

  def ensure_address
    if address.nil?
      create_address
    end
  end

end
