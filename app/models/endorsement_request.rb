class EndorsementRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  PENDING = 'pending'
  ACCEPTED = 'accepted'

  def send_endorsement_requested_email
    EndorsementMailer.endorsement_requested_email(self).deliver
  end
end
