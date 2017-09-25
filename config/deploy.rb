# config valid only for Capistrano 3.1
lock '3.1.0'

puts "Calvin CArter"

set :application, 'baseapp'
set :user, 'baseapp'

set :scm, :git
set :repo_url, 'git@github.com:CabForward/MomentumFactor.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env.production config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

# VARS ADDED BY capistrano-rbenv
set :rbenv_path, '/opt/rbenv'
set :rbenv_type, :system # or :user, depends on your rbenv setup
set :rbenv_ruby, '2.0.0-p353'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# VARS ADDED BY capistrano-bundler
# set :bundle_roles, :all
# set :bundle_binstubs, -> { shared_path.join('bin') }
# set :bundle_gemfile, -> { release_path.join('MyGemfile') }
# set :bundle_path, -> { shared_path.join('bundle') }
# set :bundle_without, %w{development test}.join(' ')
# set :bundle_flags, '--deployment --quiet'
# set :bundle_env_variables, {}

namespace :deploy do
  
  desc "Populates the Production Database"
  task :seed do
    on roles(:app), in: :sequence, wait: 5 do
      puts "\n\n=== Populating the #{fetch(:application)} database! ===\n\n"
      within release_path do
        execute :rake, 'db:seed RAILS_ENV=#{fetch(:rails_env)}'
      end
    end
  end
  
  task :stop_unicorn do
    on roles(:app), in: :sequence, wait: 5 do
      puts "\n\n=== Stopping #{fetch(:application)} unicorn process===\n\n"
      execute "sudo service #{fetch(:application)} stop"
    end
  end
  
  task :start_unicorn do
    on roles(:app), in: :sequence, wait: 5 do
      puts "\n\n=== Starting #{fetch(:application)} unicorn process===\n\n"
      execute "sudo service #{fetch(:application)} start"
    end
  end

  task :stop_memcached do
    on roles(:app), in: :sequence, wait: 5 do
      puts "\n\n=== Stopping memcached===\n\n"
      execute "sudo service memcached stop"
    end
  end
  
  task :start_memcached do
    on roles(:app), in: :sequence, wait: 5 do
      puts "\n\n=== Starting memcached===\n\n"
      execute "sudo service memcached start"
    end
  end

  before :starting, 'maintenance:enable'
  before :starting, :stop_unicorn
  before :starting, :stop_memcached

  after :published, :start_memcached
  after :published, :start_unicorn
  after :published, 'maintenance:disable'

end
