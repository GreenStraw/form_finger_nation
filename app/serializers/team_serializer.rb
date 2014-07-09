class TeamSerializer < BaseSerializer
  attributes :id, :name, :image_url, :information, :address, :sport_id
  has_many :admins, key: :admin_ids, root: :admin_ids
  has_many :fans, key: :fan_ids, root: :fan_ids
  has_many :venue_fans, key: :venue_fan_ids, root: :venue_fan_ids
  has_many :hosts, key: :host_ids, root: :host_ids
  has_many :endorsement_requests, key: :endorsement_request_ids, root: :endorsement_request_ids
  # has_one :sport, key: :sport_id, root: :sport_id

  def address
    {
      id: object.address.try(:id),
      addressable_id: object.address.try(:addressable_id),
      addressable_type: object.address.try(:addressable_id),
      street1: object.address.try(:street1),
      street2: object.address.try(:street2),
      city: object.address.try(:city),
      state: object.address.try(:state),
      zip: object.address.try(:zip),
      latitude: object.address.try(:latitude),
      longitude: object.address.try(:longitude),
      created_at: object.address.try(:created_at).try(:to_i),
      updated_at: object.address.try(:updated_at).try(:to_i)
    }
  end

  def admins
    User.with_role(:team_admin, object) || []
  end
end
