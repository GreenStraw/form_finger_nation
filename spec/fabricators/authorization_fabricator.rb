Fabricator(:authorization) do
  provider nil
  uid nil
  user_id nil   
  token nil
  secret nil
  username nil
end

# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  token      :string(255)
#  secret     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#
