Fabricator(:voucher) do
  user { Fabricate(:user) }
  package { Fabricate(:package) }
  party { Fabricate(:party) }
  redeemed_at nil
end

# == Schema Information
#
# Table name: vouchers
#
#  id         :integer          not null, primary key
#  redeemed   :boolean          default(FALSE)
#  user_id    :integer
#  package_id :integer
#  created_at :datetime
#  updated_at :datetime
#
