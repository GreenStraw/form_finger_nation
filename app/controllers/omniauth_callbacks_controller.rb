class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_tenant!
	skip_before_filter :authenticate_user!
  def all
    # puts "==============\n"*98
    p env["omniauth.auth"]
    user = User.from_omniauth(env["omniauth.auth"], current_user)
    if user && user.persisted?
      flash[:success] = "You're in! Go to 'Edit Profile' to update your profile information"
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  def failure
    flash[:warning] = "We were unable to log you into Facebook with those credentials."
    #handle you logic here..
    #and delegate to super.
    super
  end

  # def twitter_sign_in
  #   puts "=======Twitter=======\n"*98
  #   omni = request.env["omniauth.auth"]
  #   authentication = Authorization.where(:provider => omni['provider'], :uid => omni['uid']).last
  #   puts "\n uid : "+ omni['uid']
  #   puts "\n uprovider : "+ omni['provider']
  #   puts authentication.inspect
  #   if authentication
  #     flash[:success] = "You're in! Go to 'Edit Profile' to update your profile information"
  #     sign_in_and_redirect(authentication.user)
  #   elsif current_user
  #   puts "=======Current User=======\n"*98
      
  #     token = omni['credentials'].token
  #     token_secret = omni['credentials'].secret
 
  #     current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
  #     flash[:notice] = "Authentication successful."
  #     sign_in_and_redirect current_user 
  #   else
  #     user = User.new
  #     user.apply_omniauth(omni)
  #     puts "=======New User=======\n"*98
  #     #user.email = "user122342465@gmail.com"
 
  #     if user.save
  #       flash[:notice] = "Logged in."
  #       sign_in_and_redirect User.find(user.id)
  #     else
  #       session[:omniauth] = omni.except('extra')
  #       redirect_to new_user_registration_path
  #     end
  #   end
  # end

	alias_method :facebook, :all
	# alias_method :twitter, :twitter_sign_in
	alias_method :linkedin, :all
	alias_method :github, :all
	alias_method :passthru, :all
	alias_method :google_oauth2, :all

end