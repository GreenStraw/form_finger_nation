require 'spec_helper'

describe EndorsementRequest do
  describe "send_endorsement_request" do
    it "sends an email" do
      @user = Fabricate(:user)
      endorsement_request = Fabricate(:endorsement_request)
      @user.add_role(:team_admin, endorsement_request.team)
      expect { endorsement_request.send_endorsement_requested_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
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
