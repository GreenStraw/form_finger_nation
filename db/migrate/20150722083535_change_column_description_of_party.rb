class ChangeColumnDescriptionOfParty < ActiveRecord::Migration
  def change
  	remove_column :parties, :description
    add_column :parties, :description, :text
  end
end
