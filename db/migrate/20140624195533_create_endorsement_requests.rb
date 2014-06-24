class CreateEndorsementRequests < ActiveRecord::Migration
  def change
    create_table :endorsement_requests do |t|
      t.belongs_to :user
      t.belongs_to :team
      t.string :status, default: 'pending'
    end
  end
end
