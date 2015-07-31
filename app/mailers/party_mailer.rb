class PartyMailer < ActionMailer::Base
  default from: 'watchparty@foamfingernation.com'

  def watch_party_verified_email(party)
    @to = party.organizer.email
    @party = party
    mail(to: @to, subject: 'Your watch party has been verified by the venue!')
  end

  def host_fourty_eight_hour_notification_email(party)
    @party = party
    @to = @party.organizer.email
    @party_address = nil
    if @party.is_private?
      @party_address = @party.address
    else
      @party_address = @party.venue.address
    end
    @url = "#{ENV['WEB_APP_URL']}/parties/#{@party.id}"
    mail(to: @to, subject: 'Your Watch Party is coming up in two days.')
  end

  def venue_manager_fourty_eight_hour_notification_email(party)
    @party = party
    @venue = @party.venue
    @venue_manager = User.with_role(:manager, @party.venue).first
    if @venue_manager.present?
      @to = @venue_manager.email
      @url = "#{ENV['WEB_APP_URL']}/venues/#{@venue.id}"
      mail(to: @to, subject: 'A Watch Party is scheduled at your venue in two days.')
    end
  end

  def attendee_three_day_notification_email(reservation)
    @reservation = reservation
    @party = @reservation.party
    @to = @reservation.email
    @party_address = nil
    if @party.is_private
      @party_address = @party.address
    else
      @party_address = @party.venue.address
    end
    @url = "#{ENV['WEB_APP_URL']}/parties/#{@party.id}"
    mail(to: @to, subject: 'You have a Watch Party coming up.')
  end

  def sponsor_request_mailer(params,email)
    puts "-"*80
    @data = params
    puts @data
    @to = 'devzaeem.asif@gmail.com'
    
    puts "-"*80
    mail(to: @to, subject: 'Sponsor Request')
    # attachments["image"] = params[:sponsorimage] 
  end
end
