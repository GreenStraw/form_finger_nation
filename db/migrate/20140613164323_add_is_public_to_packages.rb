class AddIsPublicToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :is_public, :boolean, default: false
  end
end
