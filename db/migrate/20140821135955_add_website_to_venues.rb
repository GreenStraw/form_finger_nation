class AddWebsiteToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :website, :string
  end
end
