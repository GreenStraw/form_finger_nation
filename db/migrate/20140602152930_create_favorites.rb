class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :favoritable, polymorphic: true
      t.references :favoriter, polymorphic: true
    end
  end
end
