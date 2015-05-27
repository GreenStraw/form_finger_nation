# this approach causes errors for routing specs 
#    undefined method `url_helpers' for nil:NilClass

# RSpec.configure do |config|
#   config.before(:all) {}
#   config.before(:each) { create_new_tenant }
#   config.after(:all) {}
#   config.after(:each) { reset_tenant }
# end