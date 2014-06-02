class Party < ActiveRecord::Base
  after_update :send_notification_when_verified

  has_many :party_reservations
  has_many :attendees, through: :party_reservations, source: :user
  has_many :party_invitations
  has_many :invitees, through: :party_invitations, source: :user
  has_one :address, as: :addressable, dependent: :destroy
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  belongs_to :team
  belongs_to :sport
  belongs_to :venue

  attr_accessor :scheduled_date, :scheduled_time

  def unregistered_attendees
    party_reservations.where(:user => nil).map(&:unregistered_rsvp_email)
  end

  private

  def send_notification_when_verified
    if self.verified_changed? && self.verified
      PartyVerificationMailer.watch_party_host_verification_email(self).deliver
    end
  end

end
