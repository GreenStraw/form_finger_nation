class UserSerializer < BaseSerializer
  attributes :id, :name, :city, :state, :zip, :email, :admin
  has_many :sports, key: :sports, root: :sports
end
