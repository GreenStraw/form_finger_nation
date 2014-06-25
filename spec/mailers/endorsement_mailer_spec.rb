require "spec_helper"

describe EndorsementMailer do
  before(:each) do
    @user = Fabricate(:user)
    @team = Fabricate(:team)
    @user.add_role(:team_admin, @team)
  end
  let(:endorsement_request) { Fabricate(:endorsement_request, team: @team) }
  let(:mail) { EndorsementMailer.endorsement_requested_email(endorsement_request) }

  it 'renders the subject' do
    expect(mail.subject).to eql("Foam Finger Nation Endorsement Request")
  end

  it 'renders the receiver email' do
    expect(mail.header['To'].to_s).to eql(@user.email)
  end

  it 'renders the sender email' do
    expect(mail.header['From'].to_s).to eql('test@ffn.com')
  end
end
