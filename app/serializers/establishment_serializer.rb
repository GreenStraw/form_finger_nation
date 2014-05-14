class EstablishmentSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url, :description, :street1, :street2, :city, :state, :zip
  has_many :watch_parties
  has_one :user, embed: :object, include: true
end
