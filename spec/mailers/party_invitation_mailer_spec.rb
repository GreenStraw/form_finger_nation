require "spec_helper"

describe PartyInvitationMailer do

  describe "invitation_email" do
    let(:party_invitation) { Fabricate(:party_invitation) }
    let(:mail) { PartyInvitationMailer.invitation_email(party_invitation) }
    it 'renders the subject' do
      expect(mail.subject).to eql("You have been invited to a watch party on Foam Finger Nation!")
    end
    it 'renders the receiver email' do
      expect(mail.header['To'].to_s).to eql(party_invitation.email)
    end
    it 'renders the sender email' do
      expect(mail.header['From'].to_s).to eql('test@ffn.com')
    end
  end
  
end
