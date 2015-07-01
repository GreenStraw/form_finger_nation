class AddColumnsToParty < ActiveRecord::Migration
  def change
    add_column :parties, :max_rsvp, :integer
    add_column :parties, :type, :string
    add_column :parties, :business_name, :string
    add_column :parties, :tags, :string
  end
end
