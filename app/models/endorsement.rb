class Endorsement < ActiveRecord::Base
  belongs_to :endorsable, polymorphic: true
  belongs_to :endorser, polymorphic: true
end

# == Schema Information
#
# Table name: endorsements
#
#  id              :integer          not null, primary key
#  endorsable_id   :integer
#  endorsable_type :string(255)
#  endorser_id     :integer
#  endorser_type   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#
