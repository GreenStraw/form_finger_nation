class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website, :string
    add_column :users, :favorite_team_id, :integer
    add_column :users, :about, :string
    add_column :users, :gender, :string
    add_column :users, :location, :string
  end
end
