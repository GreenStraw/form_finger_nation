require 'spec_helper'

describe Tenant do
  
  describe 'self.create_new_tenant' do
    describe 'when new signups are permitted' do
      it '' do
        Tenant.stub(:new_signups_permitted?).and_return(true)
        tenant = Tenant.new
        Tenant.should_receive(:new).with( :name=>'tenant' ).and_return(tenant)
        tenant.should_receive(:save).and_return(true)
        Tenant.create_new_tenant({ :name=>'tenant' }, { :name=>'user'}, double(:coupon_code)).should == tenant
      end
    end
    describe 'when new signups are not permitted' do
      it 'should raise error' do
        Tenant.stub(:new_signups_permitted?).and_return(false)
        expect {
          Tenant.create_new_tenant({ :name=>'tenant' }, { :name=>'user'}, double(:coupon_code))
        }.to raise_error(Milia::Control::MaxTenantExceeded)
      end
    end
  end
  
  describe 'self.new_signups_permitted?' do
    it 'returns true' do
      Tenant.new_signups_permitted?({}).should be_truthy
    end
  end
  
  describe 'self.tenant_signup' do
    it 'does nothing' do
      Tenant.tenant_signup({}, {}, nil).should be_nil
    end
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
