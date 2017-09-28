class ImportData < ActiveRecord::Migration[5.1]
  def change
  	Rake::Task['db:data:load'].invoke
  end
end
