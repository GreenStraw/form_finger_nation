class CreateUserPurchasedPackages < ActiveRecord::Migration
  def change
    create_table :user_purchased_packages do |t|
      t.belongs_to :user
      t.belongs_to :package
      t.belongs_to :party
      t.string :charge_id
      t.timestamps
    end

    add_index(:user_purchased_packages, :user_id)
    add_index(:user_purchased_packages, :party_id)
    add_index(:user_purchased_packages, :package_id)
  end
end
