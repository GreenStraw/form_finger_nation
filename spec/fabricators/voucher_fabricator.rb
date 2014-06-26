Fabricator(:voucher) do
  user { Fabricate(:user) }
  package { Fabricate(:package) }
  redeemed false
end
