require "spec_helper"

describe PartyMailer do

  describe "watch_party_verified_email" do
    let(:party) { Fabricate(:party) }
    let(:mail) { PartyMailer.watch_party_verified_email(party) }
    it 'renders the subject' do
      expect(mail.subject).to eql("Your watch party has been verified by the venue!")
    end
    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(party.organizer.email)
    end
    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('watchparty@foamfingernation.com')
    end
  end

  describe "host_fourty_eight_hour_notification_email" do
    let(:party) { Fabricate(:party) }
    let(:mail) { PartyMailer.host_fourty_eight_hour_notification_email(party) }
    it 'renders the subject' do
      expect(mail.subject).to eql('Your Watch Party is coming up in two days.')
    end
    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(party.organizer.email)
    end
    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('watchparty@foamfingernation.com')
    end
  end

  describe "venue_manager_fourty_eight_hour_notification_email" do
    let(:party) { Fabricate(:party) }
    let(:mail) { PartyMailer.venue_manager_fourty_eight_hour_notification_email(party) }
    it 'renders the subject' do
      user = Fabricate(:user)
      user.add_role(:manager, party.venue)
      expect(mail.subject).to eql('A Watch Party is scheduled at your venue in two days.')
    end
    it 'renders the receiver email' do
      user = Fabricate(:user)
      user.add_role(:manager, party.venue)
      venue_manager = User.with_role(:manager, party.venue).first
      expect(mail.header['To'].to_s).to eql(venue_manager.email)
    end
    it 'renders the sender email' do
      user = Fabricate(:user)
      user.add_role(:manager, party.venue)
      expect(mail.header['From'].to_s).to eql('watchparty@foamfingernation.com')
    end
  end

  describe "attendee_three_day_notification_email" do
    let(:reservation) { Fabricate(:full_party_reservation) }
    let(:mail) { PartyMailer.attendee_three_day_notification_email(reservation) }
    it 'renders the subject' do
      expect(mail.subject).to eql('You have a Watch Party coming up.')
    end
    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(reservation.email)
    end
    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('watchparty@foamfingernation.com')
    end
  end

end
