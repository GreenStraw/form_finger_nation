require 'spec_helper'
require 'rake'

describe 'notification namespace rake task' do
  before(:all) {
    load "tasks/notification.rake"
    Rake::Task.define_task(:environment)
  }
  describe 'notification:venue_managerfourty_eight_hour_notification' do
    it "should call Party.send_venue_manager_fourty_eight_hour_notifications" do
      skip
      Party.should_receive(:send_venue_manager_fourty_eight_hour_notifications).once
      Rake::Task["notification:venue_manager_fourty_eight_hour_notification"].invoke
    end
  end

  describe 'notification:host_fourty_eight_hour_notification' do
    it "should call Party.send_host_fourty_eight_hour_notifications" do
      skip
      Party.should_receive(:send_host_fourty_eight_hour_notifications).once
      Rake::Task["notification:host_fourty_eight_hour_notification"].invoke
    end
  end
end
