=begin
class Tenant < ActiveRecord::Base

  acts_as_universal_and_determines_tenant

  def self.create_new_tenant(tenant_params, user_params, coupon_params)
    tenant = Tenant.new(:name => tenant_params[:name])
    if new_signups_permitted?(coupon_params)
      tenant.save    # create the tenant
    else
      raise ::Milia::Control::MaxTenantExceeded, "Sorry, new accounts not permitted at this time"
    end
    return tenant
  end

  # ------------------------------------------------------------------------
  # new_signups_not_permitted? -- returns true if no further signups allowed
  # args: params from user input; might contain a special 'coupon' code
  #       used to determine whether or not to allow another signup
  # ------------------------------------------------------------------------
  def self.new_signups_permitted?(params)
    return true
  end

  # ------------------------------------------------------------------------
  # tenant_signup -- setup a new tenant in the system
  # CALLBACK from devise RegistrationsController (milia override)
  # AFTER user creation and current_tenant established
  # args:
  #   user  -- new user  obj
  #   tenant -- new tenant obj
  #   other  -- any other parameter string from initial request
  # ------------------------------------------------------------------------
    def self.tenant_signup(user, tenant, other = nil)
      #  StartupJob.queue_startup( tenant, user, other )
      # any special seeding required for a new organizational tenant
    end

end

# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(255)
#  api_token  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
=end