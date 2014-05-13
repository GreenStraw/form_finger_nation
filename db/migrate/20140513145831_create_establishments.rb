class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.string :name
      t.string :image_url
      t.belongs_to :user
    end
  end
end
