class VoucherSerializer < BaseSerializer
  attributes :redeemed
  has_one :user, embed: :ids
  has_one :package, embed: :ids
end
