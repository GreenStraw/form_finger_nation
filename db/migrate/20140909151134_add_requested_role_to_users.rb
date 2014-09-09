class AddRequestedRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :requested_role, :string, default: 'Sports Fan'
  end
end
