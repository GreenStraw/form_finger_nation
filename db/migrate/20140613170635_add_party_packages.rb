class AddPartyPackages < ActiveRecord::Migration
  def change
    create_table :party_packages do |t|
      t.belongs_to :party
      t.belongs_to :package
    end
  end
end
