class CreatePartyReservations < ActiveRecord::Migration
  def change
    create_table :party_reservations do |t|
      t.string :email
      t.belongs_to :user
      t.belongs_to :party
    end

    add_index(:party_reservations, :user_id)
    add_index(:party_reservations, :party_id)
    add_index(:party_reservations, :email)
  end
end
