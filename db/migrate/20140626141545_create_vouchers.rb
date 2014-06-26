class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.boolean :redeemed, default: false
      t.belongs_to :user
      t.belongs_to :package
    end
  end
end
