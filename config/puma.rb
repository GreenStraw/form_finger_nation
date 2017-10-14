# Change to match your CPU core count
workers Integer(ENV['RAILS_WEB_CONCURRENCY'] || 2)

threads_min_count = Integer(ENV['RAILS_MIN_THREADS'] || 1)
threads_max_count = Integer(ENV['RAILS_MAX_THREADS'] || 6)

# Min and Max threads per worker
threads threads_min_count, threads_max_count

preload_app!
rackup      DefaultRackup

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Default to production
port        ENV['RAILS_PORT']     || 3000
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
	  # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
	  ActiveRecord::Base.establish_connection
  end
end