Fabricator(:voucher) do
  user { Fabricate(:user) }
  package { Fabricate(:package) }
  redeemed_at nil
end
