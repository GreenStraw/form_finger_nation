require 'spec_helper'

describe Party do
  describe "self.send_host_fourty_eight_hour_notifications" do
    it "sends an email for each party scheduled in two days" do
      party1 = Fabricate(:party, scheduled_for: DateTime.now+2.days)
      party2 = Fabricate(:party, scheduled_for: DateTime.now+3.days)
      party3 = Fabricate(:party, scheduled_for: DateTime.now+2.days)
      expect { Party.send_host_fourty_eight_hour_notifications }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end

  describe "self.send_venue_manager_fourty_eight_hour_notifications" do
    it "sends an email for each party scheduled in two days" do
      party1 = Fabricate(:party, scheduled_for: DateTime.now+2.days)
      party2 = Fabricate(:party, scheduled_for: DateTime.now+3.days)
      party3 = Fabricate(:party, scheduled_for: DateTime.now+2.days)
      expect { Party.send_venue_manager_fourty_eight_hour_notifications }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
end
