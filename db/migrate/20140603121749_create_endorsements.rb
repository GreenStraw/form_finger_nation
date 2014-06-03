class CreateEndorsements < ActiveRecord::Migration
  def change
    create_table :endorsements do |t|
      t.references :endorsable, polymorphic: true
      t.references :endorser, polymorphic: true
    end

    add_index :endorsements, [:endorsable_id, :endorsable_type]
    add_index :endorsements, [:endorser_id, :endorser_type]
  end
end
