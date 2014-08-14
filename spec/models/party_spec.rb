require 'spec_helper'

describe Party do

  before(:each) do
    @party = Fabricate(:party)
  end
  
  describe 'completed_purchases' do
    it 'returns voucher records' do
      expect(@party.completed_purchases.class).to eq(Voucher::ActiveRecord_AssociationRelation)
    end
  end
  
  describe "send_notification_when_verified" do
    context "verified changed and true" do
      before {
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

  describe 'unregistered_attendees' do
    it 'returns and array' do
      expect(@party.unregistered_attendees.class).to eq(Array)
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
