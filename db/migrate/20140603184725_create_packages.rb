class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :description
      t.string :image_url
      t.decimal :price
      t.boolean :active
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :venue
    end
  end
end
