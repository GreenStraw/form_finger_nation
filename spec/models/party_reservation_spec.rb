require 'spec_helper'

describe PartyReservation do
  before {
    @user = Fabricate(:user)
    @party = Fabricate(:party)
  }
  describe "create_for(email, party)" do
    context "reservation for email and party exists" do
      before {
        party_reservation = Fabricate(:party_reservation, email: @user.email, party: @party, user:nil)
        PartyReservation.should_receive(:where).and_return([party_reservation])
      }
      it "does not create reservation" do
        expect { PartyReservation.create_for(@user.email, @party) }.to change { @party.attendees.count }.by(0)
      end
    end
    context "reservation for email and party does not exists" do
      before {
        PartyReservation.should_receive(:where).and_return([])
      }
      it "creates reservation" do
        expect { PartyReservation.create_for(@user.email, @party) }.to change { @party.attendees.count }.by(1)
      end
    end
  end
end
