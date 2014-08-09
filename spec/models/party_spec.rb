require 'spec_helper'

describe Party do
  context "with parties" do
    before(:each) do
      party1 = Fabricate(:party, scheduled_for: DateTime.now+2.days)
      party2 = Fabricate(:party, scheduled_for: DateTime.now+3.days)
      party3 = Fabricate(:party, scheduled_for: DateTime.now+2.days)
    end
    context "self.send_host_fourty_eight_hour_notifications" do
      it "sends an email for each party scheduled in two days" do
        expect { Party.send_host_fourty_eight_hour_notifications }.to change { ActionMailer::Base.deliveries.count }.by(2)
      end
    end

    context "self.send_venue_manager_fourty_eight_hour_notifications" do
      it "sends an email for each party scheduled in two days" do
        expect { Party.send_venue_manager_fourty_eight_hour_notifications }.to change { ActionMailer::Base.deliveries.count }.by(2)
      end
    end

    context "self.send_attendee_three_day_notifications" do
      it "sends an to each attendee" do
        expect { Party.send_attendee_three_day_notifications }.to change { ActionMailer::Base.deliveries.count }.by(2)
      end
    end
  end

  describe "send_notification_when_verified" do
    context "verified changed and true" do
      before {
        @party = Fabricate(:party)
        @party.should_receive(:verified_changed?).and_return(true)
        @party.should_receive(:verified?).and_return(true)
      }
      it "sends an email" do
        expect { @party.send_notification_when_verified }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
    context "verified changed and not true" do
      before {
        @party = Fabricate(:party)
        @party.should_receive(:verified_changed?).and_return(true)
        @party.should_receive(:verified?).and_return(false)
      }
      it "no email" do
        expect { @party.send_notification_when_verified }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
    context "verified not changed" do
      before {
        @party = Fabricate(:party)
        @party.should_receive(:verified_changed?).and_return(false)
      }
      it "no email" do
        expect { @party.send_notification_when_verified }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end

# == Schema Information
#
# Table name: parties
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  is_private    :boolean          default(FALSE)
#  verified      :boolean          default(FALSE)
#  description   :string(255)
#  scheduled_for :datetime
#  organizer_id  :integer
#  team_id       :integer
#  sport_id      :integer
#  venue_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#
