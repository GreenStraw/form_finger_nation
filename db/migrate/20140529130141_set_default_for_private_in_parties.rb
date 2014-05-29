class SetDefaultForPrivateInParties < ActiveRecord::Migration
  def up
    change_column :parties, :private, :boolean, :default => false
  end

  def up
    change_column :parties, :private, :boolean, :default => nil
  end
end
