class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :image_url
      t.text :information
      t.belongs_to :sport
      t.timestamps
    end
  end
end
