class PartyReservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :party

  def self.create_for(email, party)
    user = User.where(email: email).first
    if PartyReservation.where(email:email, party:party).empty?
      PartyReservation.create(user: user, email: email, party: party)
    end
  end
end

# == Schema Information
#
# Table name: party_reservations
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  user_id    :integer
#  party_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
