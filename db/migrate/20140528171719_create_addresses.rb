class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.timestamps
    end
  end
end
