module TenantHelpers

  def get_current_tenant
    Tenant.current_tenant
  end

  def set_current_tenant(tenant)
    Thread.current[:tenant_id] = tenant
    Tenant.set_current_tenant tenant
  end

  def create_new_tenant
    # tenant = FactoryGirl.create(:test_tenant)
    tenant = Fabricate(:test_tenant)
    set_current_tenant tenant
    tenant
  end

  def reset_tenant
    Thread.current[:tenant_id] = nil
  end

end
