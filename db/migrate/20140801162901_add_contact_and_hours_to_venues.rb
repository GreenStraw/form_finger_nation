class AddContactAndHoursToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :phone, :string
    add_column :venues, :email, :string
    add_column :venues, :hours_sunday, :string
    add_column :venues, :hours_monday, :string
    add_column :venues, :hours_tuesday, :string
    add_column :venues, :hours_wednesday, :string
    add_column :venues, :hours_thusday, :string
    add_column :venues, :hours_friday, :string
    add_column :venues, :hours_saturday, :string
  end
end
