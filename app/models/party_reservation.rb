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
