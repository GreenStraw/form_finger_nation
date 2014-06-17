module TestData
  
  def test_data_setup
    load 'db/seeds_test.rb'
  end
  
  def test_data_teardown
    # ActiveRecord::Base.connection.tables.each do |table|
    #   ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
    # end
    # FileUtils.rm_rf('public/system/medias')
  end
  
end
