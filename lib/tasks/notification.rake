require 'active_record/fixtures'

namespace :notification do

  desc "Email notification to host for watch parties happening in two days."
  task :host_fourty_eight_hour_notification => [:environment] do
    Party.send_host_fourty_eight_hour_notifications
  end

  desc "Email notification to venue manager for watch parties happening in two days."
  task :venue_manager_fourty_eight_hour_notification => [:environment] do
    Party.send_venue_manager_fourty_eight_hour_notifications
  end
end
