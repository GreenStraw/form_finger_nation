class AddBannerToParties < ActiveRecord::Migration
  def change
  	add_column :parties, :banner, :string
  end
end
