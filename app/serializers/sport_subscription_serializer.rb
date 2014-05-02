class SportSubscriptionSerializer < BaseSerializer
  attributes :id
  has_many :sports, key: :sports, root: :sports
  has_many :users, key: :users, root: :users
end
