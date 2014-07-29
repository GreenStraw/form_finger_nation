class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string :transaction_display_id
      t.string :transaction_id
      t.datetime :redeemed_at, default: nil
      t.belongs_to :user
      t.belongs_to :package
      t.timestamps
    end
  end
end
