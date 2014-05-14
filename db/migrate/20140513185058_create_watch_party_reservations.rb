class CreateWatchPartyReservations < ActiveRecord::Migration
  def change
    create_table :watch_party_reservations do |t|
      t.belongs_to :attendee, class_name: 'User'
      t.belongs_to :watch_party
    end

    add_index(:watch_party_reservations, :attendee_id)
    add_index(:watch_party_reservations, :watch_party_id)
  end
end
