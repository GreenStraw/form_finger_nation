class AddLatitudeAndLongitudeToEstablishment < ActiveRecord::Migration
  def change
    add_column :establishments, :latitude, :float
    add_column :establishments, :longitude, :float
  end
end
