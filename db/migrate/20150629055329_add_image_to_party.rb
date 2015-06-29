class AddImageToParty < ActiveRecord::Migration
  def change
    add_column :parties, :image_url, :string
  end
end
