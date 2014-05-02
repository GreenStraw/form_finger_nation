class SportSerializer < BaseSerializer
  attributes :id, :name, :image_url
  has_many :users, key: :users, root: :users
end
