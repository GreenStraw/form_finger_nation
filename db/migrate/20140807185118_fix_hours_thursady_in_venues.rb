class FixHoursThursadyInVenues < ActiveRecord::Migration
  def change
    rename_column :venues, :hours_thusday, :hours_thursday
  end
end
