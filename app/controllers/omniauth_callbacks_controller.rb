class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_tenant!
	skip_before_filter :authenticate_user!
	def all
		p env["omniauth.auth"]
		user = User.from_omniauth(env["omniauth.auth"], current_user)
		if user.persisted?
			flash[:notice] = "You are in..!!! Go to edit profile to see the status for the accounts"
			sign_in_and_redirect(user)
		else
			session["devise.user_attributes"] = user.attributes
			redirect_to new_user_registration_url
		end
	end

	  def failure
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
  
=begin

  def self.provides_callback_for(provider)
      
      class_eval %Q{
        def #{provider}
 
          @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

          if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
          else
            session["devise.#{provider}_data"] = env["omniauth.auth"]
            redirect_to new_user_registration_url
          end
        end
      }
    end


  #[:twitter, :facebook, :linked_in].each do |provider|
  #[:facebook].each do |provider| #
    provides_callback_for :facebook
    #end
=end
=begin
  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end
=end
end