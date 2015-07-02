class AddSlugToParty < ActiveRecord::Migration
  def change
    add_column :parties, :slug, :string
    add_index :slug
  end
end
