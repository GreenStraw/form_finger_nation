=begin
Example 

Rails.application.config.assets.precompile += 
  %w(*.png *.jpg *.jpeg *.gif vendor/somefile.js vendor/somefile.css \
     vendor/bootstrap/*.js vendor/bootstrap/*.css \
     vendor/bootstrap/**/*.js vendor/bootstrap/**/*.css)

=end

#Rails.application.config.assets.precompile += 
#	%w(*.png *.jpg *.jpeg *.gif vendor/javascripts/*.js vendor/stylesheets/*.css \
#     vendor/stylesheets/*.erb)

#Rails.application.config.assets.precompile += %w( home_page_parallax.js )

#Rails.application.config.assets.precompile += 
#%w(*.png *.jpg *.jpeg *.gif *.js *.css *.erb)

  # Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

    # Adding Webfonts to the Asset Pipeline
Rails.application.config.assets.precompile << Proc.new { |path|
      if path =~ /\.(eot|svg|ttf|woff|otf)\z/
        true
      end
    }