Fabricator(:package) do
  name "test package"
  description "wings for 50 cents"
  image_url nil
  price 5.00
  active true
  start_date DateTime.now-1.days
  end_date DateTime.now+7.days
  venue { Fabricate(:venue) }
end
