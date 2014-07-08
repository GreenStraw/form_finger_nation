class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :configure_permitted_parameters

  # POST /resource
  def create
    sign_up_params.delete(:current_password)
    build_resource(sign_up_params)

    if resource.save
      resource.confirm!
      resource.ensure_authentication_token
      return render json: RegistrationUserSerializer.new(resource).to_json, status: 201
    else
      render json: { :errors => resource.errors.full_messages }, status: 422
      return
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address, address_attributes: [:street1, :street2, :city, :state, :zip])
    end
  end

  def sign_up_params
    params[:user].delete(:current_password)
    params.require(:user).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address, address_attributes: [:street1, :street2, :city, :state, :zip])
  end
end
