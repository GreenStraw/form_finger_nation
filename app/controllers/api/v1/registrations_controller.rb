module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      skip_before_action :verify_authenticity_token
      before_action :configure_permitted_parameters

      def create
        puts 'PARAMS'
        puts params.inspect
        # TODO: fixme
        # This is needed to get rid of the mass security error on this field.
        # It is a part of the ember data model, but I'm not sure how to remove
        # it from the JSON request when we're not doing the update.

        sign_up_params.delete(:current_password)

        build_resource(sign_up_params)

        if resource.save
          if resource.active_for_authentication?
            sign_up(resource_name, resource)
          end
          render json: resource, status: 201
          return
        else
          render json: { :errors => resource.errors.full_messages }, status: 422
          return
        end
      end

    protected

      def configure_permitted_parameters
        puts 'TEST'
        devise_parameter_sanitizer.for(:sign_up) do |u|
          u.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address)
        end
      end

      def sign_up_params
        params[:user].delete(:current_password)
        params.require(:user).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, :address, {:sports=>[], :teams=>[]})
      end
    end
  end
end
