######## MODEL EXAMPLES #########

shared_examples 'a tenanted model' do
  context 'when there are many tenants' do
    before do
      @tenant1 = create_new_tenant
      @class1 = FactoryGirl.create_list(described_class, 10)

      @tenant2 = create_new_tenant
      @class2 = FactoryGirl.create_list(described_class, 10)
    end

    it 'should isolate by tenant' do
      set_current_tenant @tenant1
      expect(described_class.all).to match_array @class1

      set_current_tenant @tenant2
      expect(described_class.all).to match_array @class2
    end
  end
end

shared_examples 'a universal model' do
  context 'when there are many tenants' do
    before do
      @tenant1 = create_new_tenant
      @class1 = FactoryGirl.create_list(described_class, 10)

      @tenant2 = create_new_tenant
      @class2 = FactoryGirl.create_list(described_class, 10)
    end

    it 'should not isolate by tenant' do
      set_current_tenant @tenant1
      expect(described_class.all).to match_array(@class1 + @class2)

      set_current_tenant @tenant2
      expect(described_class.all).to match_array(@class1 + @class2)
    end
  end
end

######## CONTROLLER EXAMPLES #########

shared_examples 'an authenticated controller' do |methods|

  methods.each do |method|

    describe "GET #{method}" do

      context 'when not logged in' do
        
        before{ logout }
        
        it "should return http status 302" do
          get method
          response.should_not be_success
        end
        
        it "should redirect to login page" do
          get method
          response.should redirect_to(new_user_session_path)
        end
      
      end

      context 'when logged in' do
        
        before{ login(:staff) }        
        
        it "should return http status 200" do
          get method
          response.should be_success
        end
        
        it "should render #{method} view" do
          get method
          response.should render_template(method)
        end
      end

    end

  end
end
