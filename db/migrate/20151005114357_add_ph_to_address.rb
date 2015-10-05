class AddPhToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :ph_number, :string
  end
end
