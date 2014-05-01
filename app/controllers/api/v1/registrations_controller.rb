
module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      before_action :configure_permitted_parameters

      def create
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

      def update
        resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
        prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

        if resource.update_with_password(account_update_params)
          sign_in resource_name, resource, :bypass => true
          render json: resource, status: 201
          return
        else
          clean_up_passwords resource
          render json: resource, status: 422
        end
      end

    protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) do |u|
          u.permit(:name, :admin, :email, :city, :state, :zip, :password, :password_confirmation)
        end

        devise_parameter_sanitizer.for(:account_update) do |u|
          u.permit(:name, :admin, :email, :city, :state, :zip, :current_password, :password, :password_confirmation)
        end
      end

      def sign_up_params
        params[:user].delete(:current_password)
        params.require(:user).permit(:name, :admin, :email, :city, :state, :zip, :password, :password_confirmation)
      end

      def account_update_params
        params.require(:user).permit(:name, :admin, :email, :city, :state, :zip, :current_password, :password, :password_confirmation)
      end
    end
  end
end
