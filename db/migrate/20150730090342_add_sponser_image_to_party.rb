class AddSponserImageToParty < ActiveRecord::Migration
  def change
    add_column :parties, :sponser_image, :string
  end
end
