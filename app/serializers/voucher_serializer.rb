class VoucherSerializer < BaseSerializer
  attributes :id, :redeemed
  has_one :user, key: :user_id, root: :user_id
  has_one :package, key: :package_id, root: :package_id
end
