class PartySerializer < BaseSerializer

  #removed attribute purchase_total,voucher_count

  attributes :name, :description, :scheduled_for, :is_private, :verified, :address
  has_many :party_invitations, embed: :ids
  has_many :unregistered_attendees, embed: :ids
  has_many :attendees, embed: :ids
  has_many :packages, embed: :ids
  has_many :vouchers, embed: :ids
  has_one :organizer, embed: :ids
  has_one :team, embed: :ids, include: true
  has_one :sport, embed: :ids
  has_one :venue, embed: :ids, include: true

  private

  #def purchase_total
  #  object.completed_purchases.map(&:package).sum(&:price).to_f
  #end

  #def voucher_count
  #  object.completed_purchases.count
  #end

  def address
    if object.is_private?
      AddressSerializer.new(object.address)
    else
      AddressSerializer.new(object.venue.address)
    end
  end

  def scheduled_for
    object.scheduled_for.to_i
  end

  def unregistered_attendees
    object.party_reservations.where(:user_id => nil)
  end

  def comments
    object.root_comments
  end
end
