class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :configure_permitted_parameters

  # POST /resource
  def create
    sign_up_params.delete(:current_password)

    build_resource(sign_up_params)

    if resource.save
      return render json: resource, status: 201
    else
      render json: { :errors => resource.errors.full_messages }, status: 422
      return
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address)
    end
  end

  def sign_up_params
    params[:user].delete(:current_password)
    params.require(:user).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address, {:sports=>[], :teams=>[]})
  end
end
