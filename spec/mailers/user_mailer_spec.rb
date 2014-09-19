require "spec_helper"

describe UserMailer do

  describe "welcome_email" do
    before(:each) do
      @user = Fabricate(:user)
    end
    let(:mail) { UserMailer.welcome_email(@user) }
    it 'renders the subject' do
      expect(mail.subject).to eql("Welcome to Foam Finger Nation!")
    end
    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(@user.email)
    end
    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('Foam Finger Nation <Info@foamfingernation.com>')
    end
  end

  describe "alumni_group_email" do
    before(:each) do
      @user = Fabricate(:user)
    end
    let(:mail) { UserMailer.alumni_group_email(@user) }
    it 'renders the subject' do
      expect(mail.subject).to eql("Welcome to Foam Finger Nation!")
    end
    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(@user.email)
    end
    it 'renders the bcc email' do
      expect(mail.header['Bcc'].to_s).to eql('alumnigroups@foamfingernation.com')
    end
    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('Foam Finger Nation <Alumnigroups@foamfingernation.com>')
    end
  end

  describe "venue_email" do
    before(:each) do
      @user = Fabricate(:user)
    end
    let(:mail) { UserMailer.venue_email(@user) }
    it 'renders the subject' do
      expect(mail.subject).to eql("Welcome to Foam Finger Nation!")
    end
    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(@user.email)
    end
    it 'renders the bcc email' do
      expect(mail.header['Bcc'].to_s).to eql('Sportsbars@foamfingernation.com')
    end
    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('Foam Finger Nation <Sportsbars@foamfingernation.com>')
    end
  end

end


