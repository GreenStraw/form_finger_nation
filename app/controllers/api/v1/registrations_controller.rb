class Api::V1::RegistrationsController < Devise::RegistrationsController
  require 'koala'
  respond_to :json
  before_action :configure_permitted_parameters

  # POST /resource
  def create
    sign_up_params.delete(:current_password)
    build_resource(sign_up_params)

    if resource.save
      if resource.address.nil?
        resource.create_address
      end
      resource.confirm!
      resource.ensure_authentication_token
      return render json: RegistrationUserSerializer.new(resource).to_json, status: 201
    else
      render json: { :errors => resource.errors.full_messages }, status: 422
      return
    end
  end

  def create_facebook
    fb_user = User.facebook_user(sign_up_params[:facebook_access_token])
    fb_details = fb_user.get_object("me")

    if fb_details["id"].present?
      params[:uid] = fb_details["id"]
      params[:provider] = 'facebook'
      params[:password] = SecureRandom.hex(20)
      params[:password_confirmation] = params[:password]
    else
      errors.add(:base, "Facebook User Not Valid")
    end

    create_user
  end

  private

  def creating_facebook_user?
    params[:user][:access_token].present? && params[:user][:password].blank?
  end

  def set_facebook_user_password
    params[:password] = SecureRandom.hex(20)
    params[:password_confirmation] = params[:password]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address, :facebook_access_token, address_attributes: [:street1, :street2, :city, :state, :zip])
    end
  end

  def sign_up_params
    params[:user].delete(:current_password)
    params.require(:user).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address, :facebook_access_token, address_attributes: [:street1, :street2, :city, :state, :zip])
  end
end
