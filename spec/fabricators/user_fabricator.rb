Fabricator(:user) do
  tenant_id nil
  confirmed_at DateTime.now
  first_name 'Test'
  last_name 'User'
  username { sequence(:username) { |i| "foo#{i}"} }
  email { sequence(:email) { |i| "foo#{i}@example.com"} }
  password 'password'
  password_confirmation 'password'
  followed_sports []
  followed_teams []
end

# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string(255)      default(""), not null
#  encrypted_password           :string(255)      default(""), not null
#  reset_password_token         :string(255)
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :string(255)
#  last_sign_in_ip              :string(255)
#  confirmation_token           :string(255)
#  confirmed_at                 :datetime
#  confirmation_sent_at         :datetime
#  unconfirmed_email            :string(255)
#  failed_attempts              :integer          default(0), not null
#  unlock_token                 :string(255)
#  locked_at                    :datetime
#  skip_confirm_change_password :boolean          default(FALSE)
#  tenant_id                    :integer
#  authentication_token         :string(255)
#  first_name                   :string(255)
#  last_name                    :string(255)
#  role                         :string(255)
#  username                     :string(255)
#  provider                     :string(255)
#  uid                          :string(255)
#  customer_id                  :string(255)
#  facebook_access_token        :string(255)
#  image_url                    :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  name                         :string(255)
#
