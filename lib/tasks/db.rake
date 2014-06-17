# based off of http://derekdevries.com/2009/04/13/rails-seed-data/

require 'active_record/fixtures'

namespace :db do

  desc "Seed the database with develop/ fixtures."
  task :develop => [:environment] do        
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
  end
  
  task :seed_test_data=> :environment do
    load_seeds 'test'
    puts "Test data loaded."
  end
  
  task :annotate do
    system("annotate --position after")    
  end
  
  private
  
  def load_seeds(environment)
   require File.join(Rails.root, 'db', environment + '_seeds.rb')
  end 
  
end
