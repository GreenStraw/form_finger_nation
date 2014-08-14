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
#  id                     :integer          not null, primary key
#  transaction_display_id :string(255)
#  transaction_id         :string(255)
#  redeemed_at            :datetime
#  user_id                :integer
#  package_id             :integer
#  party_id               :integer
#  created_at             :datetime
#  updated_at             :datetime
#
