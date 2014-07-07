class CreatePartyPackages < ActiveRecord::Migration
  def change
    create_table :party_packages do |t|
      t.belongs_to :party
      t.belongs_to :package
      t.timestamps
    end
  end
end
