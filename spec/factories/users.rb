# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  # New user cannot be created without current tenant being set
  factory :user do
    tenant_id nil
    sequence(:first_name) {|n| "FirstName#{n}" }
    sequence(:last_name) {|n| "LastName#{n}" }
    sequence(:email) {|n| "test_user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    
    # User CanCan roles
    trait(:admin) { role :admin }
    trait(:staff) { role :staff }
    trait(:client) { role :client }
  end

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
#  first_name                   :string(255)
#  last_name                    :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  role                         :string(255)
#
