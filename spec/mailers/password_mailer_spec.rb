require "spec_helper"

describe PasswordMailer do
  let(:user) { Fabricate(:user) }
  let(:mail) { PasswordMailer.password_reset_email(user) }

  it 'renders the subject' do
    expect(mail.subject).to eql("Password reset")
  end

  it 'renders the receiver email' do
    expect(mail.header['To'].to_s).to eql(user.email)
  end

  it 'renders the sender email' do
    expect(mail.header['From'].to_s).to eql('test@ffn.com')
  end
end
