class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :description
      t.string :image_url
      t.belongs_to :user
    end
    add_index(:venues, :user_id)
  end
end
