class Party < ActiveRecord::Base
  acts_as_commentable
  validates :name, presence: true
  validates :scheduled_for, presence: true

  after_update :send_notification_when_verified

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
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (Time.now+2.days).beginning_of_day, (Time.now+2.days).end_of_day)
    parties.each do |party|
      PartyMailer.host_fourty_eight_hour_notification_email(party).deliver
    end
  end

  def self.send_venue_manager_fourty_eight_hour_notifications
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (Time.now+2.days).beginning_of_day, (Time.now+2.days).end_of_day)
    parties.each do |party|
      PartyMailer.host_fourty_eight_hour_notification_email(party).deliver
    end
  end

  def unregistered_attendees
    party_reservations.where(:user => nil).map(&:unregistered_rsvp_email)
  end

  def isPrivate
    return private?
  end

  private

  def send_notification_when_verified
    if self.verified_changed? && self.verified
      PartyVerificationMailer.watch_party_host_verification_email(self).deliver
    end
  end

end
