class AddAddressAndAdminToTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.belongs_to :admin, class_name: 'User'
    end
    add_index(:teams, :admin_id)
  end
end
