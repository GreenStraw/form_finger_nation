class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :description
      t.string :image_url
      t.decimal :price
      t.boolean :active, boolean: true
      t.boolean :is_public, default: false
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :venue
      t.timestamps
    end
  end
end
