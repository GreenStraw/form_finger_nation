class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :favoritable, polymorphic: true
      t.references :favoriter, polymorphic: true
      t.timestamps
    end

    add_index :favorites, [:favoritable_id, :favoritable_type]
    add_index :favorites, [:favoriter_id, :favoriter_type]
  end
end
