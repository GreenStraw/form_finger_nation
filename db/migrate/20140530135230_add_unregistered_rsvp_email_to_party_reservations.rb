class AddUnregisteredRsvpEmailToPartyReservations < ActiveRecord::Migration
  def change
    add_column :party_reservations, :unregistered_rsvp_email, :string
  end
end
