class RemoveAddressAttributesFromVenues < ActiveRecord::Migration
  def change
    remove_column :venues, :street1
    remove_column :venues, :street2
    remove_column :venues, :city
    remove_column :venues, :state
    remove_column :venues, :zip
    remove_column :venues, :latitude
    remove_column :venues, :longitude
  end
end
