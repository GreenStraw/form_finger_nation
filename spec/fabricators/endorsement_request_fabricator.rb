Fabricator(:endorsement_request) do
  user { Fabricate(:user) }
  team { Fabricate(:team) }
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
