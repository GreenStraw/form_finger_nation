class TeamSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :name, :image_url
end
