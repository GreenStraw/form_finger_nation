require "spec_helper"

describe RegistrationMailer do
  let(:user) { Fabricate(:user) }

  context "welcome_email" do
    let(:mail) { RegistrationMailer.welcome_email(user) }

    it 'renders the subject' do
      expect(mail.subject).to eql("Welcome to Foam Finger Nation!")
    end

    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(user.email)
    end

    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('test@ffn.com')
    end
  end

  context "facebook_welcome_email" do
    let(:mail) { RegistrationMailer.facebook_welcome_email(user) }

    it 'renders the subject' do
      expect(mail.subject).to eql("Welcome to Foam Finger Nation!")
    end

    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(user.email)
    end

    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('test@ffn.com')
    end
  end
end
