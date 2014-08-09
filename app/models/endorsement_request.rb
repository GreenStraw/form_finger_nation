class EndorsementRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  PENDING = 'pending'
  ACCEPTED = 'accepted'

  def send_endorsement_requested_email
    EndorsementMailer.endorsement_requested_email(self).deliver
  end
end

# == Schema Information
#
# Table name: endorsement_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  team_id    :integer
#  status     :string(255)      default("pending")
#  created_at :datetime
#  updated_at :datetime
#
