require 'active_record/fixtures'

namespace :notification do

  desc "Email notification to host for watch parties happening in two days."
  task :host_fourty_eight_hour_notification => [:environment] do
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (DateTime.now+2.days).beginning_of_day, (DateTime.now+2.days).end_of_day)
    parties.each do |party|
      PartyMailer.host_fourty_eight_hour_notification_email(party).deliver
    end
  end

  desc "Email notification to venue manager for watch parties happening in two days."
  task :venue_manager_fourty_eight_hour_notification => [:environment] do
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (DateTime.now+2.days).beginning_of_day, (DateTime.now+2.days).end_of_day)
    parties.each do |party|
      PartyMailer.venue_manager_fourty_eight_hour_notification_email(party).deliver
    end
  end

  desc "Email notification to party attendees for watch parties happening in three days"
  task :attendee_three_day_notification_email => [:environment] do
    parties = Party.where("scheduled_for >= ? AND scheduled_for <= ?", (DateTime.now+3.days).beginning_of_day, (DateTime.now+3.days).end_of_day)
    parties.each do |party|
      party.party_reservations.each do |reservation|
        PartyMailer.attendee_three_day_notification_email(reservation).deliver
      end
    end
  end
  
end
