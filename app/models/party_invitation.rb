class PartyInvitation < ActiveRecord::Base
  before_validation :create_uuid, on: :create
  validates_presence_of :uuid
  validates_uniqueness_of :uuid

  belongs_to :inviter, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :user
  belongs_to :party

  private

  def create_uuid
    self.uuid = SecureRandom.hex(20)
  end
end
