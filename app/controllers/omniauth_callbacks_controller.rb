class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_tenant!
	skip_before_filter :authenticate_user!
	def all
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


	alias_method :facebook, :all
	alias_method :twitter, :all
	alias_method :linkedin, :all
	alias_method :github, :all
	alias_method :passthru, :all
	alias_method :google_oauth2, :all

end