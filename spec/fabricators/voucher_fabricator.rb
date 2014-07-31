Fabricator(:voucher) do
  user { Fabricate(:user) }
  package { Fabricate(:package) }
  party { Fabricate(:party) }
  redeemed_at nil
end
