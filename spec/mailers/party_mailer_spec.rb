require "spec_helper"

describe PartyMailer do
  let(:party) { Fabricate(:party) }
  let(:mail) { PartyMailer.watch_party_verified_email(party) }

  it 'renders the subject' do
    expect(mail.subject).to eql("Your watch party has been verified by the venue!")
  end

  it 'renders the receiver email' do
    expect(mail.header['To'].to_s).to eql(party.organizer.email)
  end

  it 'renders the sender email' do
    expect(mail.header['From'].to_s).to eql('test@ffn.com')
  end
end
