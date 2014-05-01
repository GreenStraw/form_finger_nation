module Api
  module V1
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController
      def facebook
        @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

        if !@user.nil? && @user.persisted?
          @user.ensure_authentication_token!
          redirect_to "/callback?auth_token=#{@user.authentication_token}&remember=true"
        else
          redirect_to "/err_500"
        end
      end

      def generic_provider
        @user = User.find_for_generic_provider(request.env["omniauth.auth"])

        if !@user.nil? && @user.persisted?
          @user.ensure_authentication_token!
          redirect_to "/callback?auth_token=#{@user.authentication_token}&remember=true"
        else
          redirect_to "/err_500"
        end
      end
    end
  end
end
