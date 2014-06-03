class CreatePartyReservations < ActiveRecord::Migration
  def change
    create_table :party_reservations do |t|
      t.string :unregistered_rsvp_email
      t.belongs_to :user
      t.belongs_to :party
    end

    add_index(:party_reservations, :user_id)
    add_index(:party_reservations, :party_id)
  end
end
