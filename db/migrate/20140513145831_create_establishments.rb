class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.string :name
      t.string :description
      t.string :image_url
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.belongs_to :user
    end
    add_index(:establishments, :user_id)
  end
end
