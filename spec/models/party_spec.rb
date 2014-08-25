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
  
  describe 'search by values expecting no match' do
    before {
      @party = Fabricate(:party, name: "my test party")
    }
    it "no results" do
      @results = Party.search("test string")
      expect(@results).to eq([[],[],[]])
    end
  end
  
  describe 'search blank values expecting matches' do
    before {
      @party = Fabricate(:party, name: "my test party")
    }
    it "no results" do
      @results = Party.search("")
      expect(@results.count).to eq(3)
    end
  end
  
  describe 'search by params with blank values expecting matches' do
    before {
      @party = Fabricate(:party, name: "my test party")
    }
    it "no results" do
      @results = Party.search_by_params("")
      expect(@results.count).to eq(3)
    end
  end
  

  describe 'search with params values expecting matches' do
    before {
      @party = Fabricate(:party, name: "my test party")
    }
    it "should have results" do
      @results = Party.search_by_params({search_item: "my test party"})
      expect(@results[0].count).to eq(1)
    end
  end
  
  describe 'search with location params values expecting matches' do
    it "should have results" do
      @results = Party.search_by_params({search_location: "Austin, Tx"})
      expect(@results[0].count).to eq(1)
    end
  end
  

  describe 'search with params values and geo location expecting matches' do
    before {
      @party = Fabricate(:party, name: "my test party")
    }
    it "should have results" do
      @results = Party.search_by_params({search_item: "my test party", search_location: "austin, tx"})
      expect(@results[0].count).to eq(1)
    end
  end

  describe 'search by values expecting match' do
    before {
      @party = Fabricate(:party, name: "my test party")
      @test_party = Party.where(name: "my test party")
    }
    it "results" do
      @results = Party.search("my test")
      expect(@results[0][0]).to eq(@test_party[0])
    end
  end
  
  describe 'search by location expecting match' do
    before {
      @address = Fabricate(:address, street1: "10717 Pall Mall", city: "Austin", state: "TX", zip: "78748")
      @address.save
      @venue = Fabricate(:venue, address: @address)
      @party = Fabricate(:party, name: "my test party", venue: @venue)
      @test_party = Party.where(name: "my test party")
    }
    it "results" do
      @results = Party.geo_search("Austin, TX", 25)
      expect(@results.count).to eq(2)
    end
  end
  

  describe "send invites " do
    before {
      @party = Fabricate(:party, name: "my test party")
      @user = Fabricate(:user)
    }
    it "sends invite" do
      count = PartyInvitation.count
      params = {:invites => {:email => @user.email}}
      @party.handle_invites(params,  @user)
      expect(PartyInvitation.count).to eq(count + 1)
    end
  end
  
  describe "do not send invites if user has already been invited" do
    before {
      @party = Fabricate(:party, name: "my test party")
      @user = Fabricate(:user)
    }
    it "sends invite" do
      params = {:invites => {:email => @user.email}}
      @party.handle_invites(params,  @user)
      count = PartyInvitation.count      
      @party.handle_invites(params,  @user)
      expect(PartyInvitation.count).to eq(count)
    end
  end
  
  describe "do not send invites if email is invalid" do
    before {
      @party = Fabricate(:party, name: "my test party")
      @user = Fabricate(:user, email: "test@me")
    }
    it "sends invite" do
      count = PartyInvitation.count
      params = {:invites => {:email => @user.email}}
      @party.handle_invites(params,  @user.id)
      expect(PartyInvitation.count).to eq(count)
    end
  end
  


  

  describe "send invites " do
    before {
      @party = Fabricate(:party, name: "my test party")
      @user = Fabricate(:user)
    }
    it "sends invite" do
      count = PartyInvitation.count
      params = {:invites => {:email => @user.email}}
      @party.handle_invites(params,  @user)
      expect(PartyInvitation.count).to eq(count + 1)
    end
  end
  
  describe "do not send invites if user has already been invited" do
    before {
      @party = Fabricate(:party, name: "my test party")
      @user = Fabricate(:user)
    }
    it "sends invite" do
      params = {:invites => {:email => @user.email}}
      @party.handle_invites(params,  @user)
      count = PartyInvitation.count      
      @party.handle_invites(params,  @user)
      expect(PartyInvitation.count).to eq(count)
    end
  end
  
  describe "do not send invites if email is invalid" do
    before {
      @party = Fabricate(:party, name: "my test party")
      @user = Fabricate(:user, email: "test@me")
    }
    it "sends invite" do
      count = PartyInvitation.count
      params = {:invites => {:email => @user.email}}
      @party.handle_invites(params,  @user.id)
      expect(PartyInvitation.count).to eq(count)
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
